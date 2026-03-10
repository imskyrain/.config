-- 全局 Session 管理（Sublime Text 风格）
-- 实时保存，强制退出后自动恢复
-- 支持未命名文件内容保存
return {
	dir = vim.fn.stdpath("config"),
	name = "global-session",
	enabled = true, -- 启用全局会话
	lazy = false,
	priority = 100,
	config = function()
		-- 会话文件路径
		local session_dir = vim.fn.stdpath("state") .. "/sessions/"
		local global_session = session_dir .. "global.vim"
		local unnamed_dir = session_dir .. "unnamed/"

		-- 确保目录存在
		vim.fn.mkdir(session_dir, "p")
		vim.fn.mkdir(unnamed_dir, "p")

		-- Session 配置（完整保存）
		vim.opt.sessionoptions = {
			"buffers", -- 所有缓冲区
			"curdir", -- 当前目录
			"tabpages", -- 标签页
			"winsize", -- 窗口大小
			"help", -- help 窗口
			"globals", -- 全局变量
			"skiprtp", -- 跳过 runtimepath
			"folds", -- 折叠
			"blank", -- 支持未命名的空 buffer
		}

		-- 排除的缓冲区类型
		local excluded_buftypes = {
			"nofile",
			"terminal",
			"quickfix",
			"prompt",
			"help",
		}

		-- 排除的文件类型
		local excluded_filetypes = {
			"neo-tree",
			"aerial",
			"toggleterm",
			"lazy",
			"mason",
			"notify",
			"noice",
			"alpha",
			"dashboard",
		}

		-- 检查缓冲区是否应该保存
		local function should_save_buffer(bufnr)
			local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
			local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

			-- 排除特殊缓冲区类型
			if vim.tbl_contains(excluded_buftypes, buftype) then
				return false
			end

			-- 排除特殊文件类型
			if vim.tbl_contains(excluded_filetypes, filetype) then
				return false
			end

			return true
		end

		-- 检查缓冲区是否有内容
		local function buffer_has_content(bufnr)
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			for _, line in ipairs(lines) do
				if line ~= "" then
					return true
				end
			end
			return false
		end

		-- 保存单个未命名缓冲区（实时保存）
		local function save_unnamed_buffer(bufnr)
			local bufname = vim.api.nvim_buf_get_name(bufnr)

			-- 只处理未命名缓冲区
			if bufname ~= "" then
				return false
			end

			if not should_save_buffer(bufnr) then
				return false
			end

			if not buffer_has_content(bufnr) then
				return false
			end

			-- 保存内容
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local unnamed_file = unnamed_dir .. "buffer_" .. bufnr .. ".txt"
			vim.fn.writefile(lines, unnamed_file)

			-- 更新索引文件
			local list_file = unnamed_dir .. "list.vim"
			local existing_files = {}

			if vim.fn.filereadable(list_file) == 1 then
				existing_files = vim.fn.readfile(list_file)
			end

			-- 添加新文件（如果不存在）
			local found = false
			for _, file in ipairs(existing_files) do
				if file == unnamed_file then
					found = true
					break
				end
			end

			if not found then
				table.insert(existing_files, unnamed_file)
				vim.fn.writefile(existing_files, list_file)
			end

			return true
		end

		-- 保存所有未命名缓冲区
		local function save_unnamed_buffers()
			local saved_count = 0

			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) then
					if save_unnamed_buffer(bufnr) then
						saved_count = saved_count + 1
					end
				end
			end

			return saved_count
		end

		-- 恢复未命名缓冲区
		local function restore_unnamed_buffers()
			local list_file = unnamed_dir .. "list.vim"
			if vim.fn.filereadable(list_file) == 0 then
				return 0
			end

			local files = vim.fn.readfile(list_file)
			local restored = 0

			for _, file in ipairs(files) do
				if vim.fn.filereadable(file) == 1 then
					-- 创建新的未命名缓冲区并加载内容
					vim.cmd("enew")
					local bufnr = vim.api.nvim_get_current_buf()
					local lines = vim.fn.readfile(file)
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

					-- 标记为已修改（模拟 Sublime Text）
					vim.api.nvim_buf_set_option(bufnr, "modified", true)
					restored = restored + 1

					-- 删除临时文件
					vim.fn.delete(file)
				end
			end

			-- 清理列表文件
			if restored > 0 then
				vim.fn.delete(list_file)
			end

			return restored
		end

		-- 关闭特殊窗口
		local function close_special_windows()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local ok, config = pcall(vim.api.nvim_win_get_config, win)
				if ok then
					-- 关闭浮动窗口
					if config.relative ~= "" then
						pcall(vim.api.nvim_win_close, win, false)
					else
						-- 检查窗口缓冲区类型
						local bufnr = vim.api.nvim_win_get_buf(win)
						if not should_save_buffer(bufnr) then
							pcall(vim.api.nvim_win_close, win, false)
						end
					end
				end
			end
		end

		-- 保存全局会话
		local function save_global_session(silent)
			silent = silent or false

			-- 关闭特殊窗口
			close_special_windows()

			-- 保存未命名缓冲区
			local unnamed_count = save_unnamed_buffers()

			-- 保存会话
			local ok, err = pcall(function()
				vim.cmd("mksession! " .. global_session)
			end)

			if ok then
				-- 成功提示（仅在手动保存时显示）
				if not silent and vim.v.exiting == vim.NIL then
					local msg = "✓ 全局会话已保存"
					if unnamed_count > 0 then
						msg = msg .. string.format("（包括 %d 个未命名文件）", unnamed_count)
					end
					vim.notify(msg, vim.log.levels.INFO)
				end
			else
				if not silent then
					vim.notify("保存会话失败: " .. tostring(err), vim.log.levels.ERROR)
				end
			end
		end

		-- 加载全局会话
		local function load_global_session()
			if vim.fn.filereadable(global_session) == 0 then
				return
			end

			-- 加载会话
			local ok, err = pcall(function()
				vim.cmd("silent! source " .. global_session)
			end)

			if ok then
				-- 恢复未命名缓冲区
				local unnamed_count = restore_unnamed_buffers()

				-- 成功提示
				local msg = "✓ 会话已恢复"
				if unnamed_count > 0 then
					msg = msg .. string.format("（包括 %d 个未命名文件）", unnamed_count)
				end
				vim.notify(msg, vim.log.levels.INFO)
			else
				vim.notify("恢复会话失败: " .. tostring(err), vim.log.levels.WARN)
			end
		end

		-- VimEnter: 自动恢复会话
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("global_session_restore", { clear = true }),
			callback = function()
				-- 检查是否有会话可以恢复
				local has_session = vim.fn.filereadable(global_session) == 1
				local has_unnamed = vim.fn.filereadable(unnamed_dir .. "list.vim") == 1

				-- 如果有会话或未命名文件，且不是从 stdin 读取
				if (has_session or has_unnamed) and not vim.g.started_with_stdin then
					-- 只在无参数或单个空 buffer 时恢复
					local should_restore = false

					if vim.fn.argc() == 0 then
						should_restore = true
					else
						-- 检查是否只有一个空 buffer（可能是错误恢复后的情况）
						local bufs = vim.api.nvim_list_bufs()
						local loaded_bufs = 0
						for _, buf in ipairs(bufs) do
							if vim.api.nvim_buf_is_loaded(buf) then
								loaded_bufs = loaded_bufs + 1
							end
						end
						if loaded_bufs <= 1 then
							local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
							if #lines == 1 and lines[1] == "" then
								should_restore = true
							end
						end
					end

					if should_restore then
						-- 延迟加载，等待其他插件初始化
						vim.defer_fn(function()
							load_global_session()
						end, 100)
					end
				end
			end,
			nested = true,
		})

		-- 退出时自动保存会话（多个事件确保保存）
		local save_group = vim.api.nvim_create_augroup("global_session_save", { clear = true })

		-- VimLeavePre: 正常退出
		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = save_group,
			callback = function()
				save_global_session(true)
			end,
		})

		-- VimLeave: 确保保存
		vim.api.nvim_create_autocmd("VimLeave", {
			group = save_group,
			callback = function()
				save_global_session(true)
			end,
		})

		-- 实时保存未命名缓冲区（Sublime Text 风格）
		local realtime_group = vim.api.nvim_create_augroup("global_session_realtime", { clear = true })

		-- 文本改变后保存
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			group = realtime_group,
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				-- 延迟保存，避免频繁写入
				vim.defer_fn(function()
					save_unnamed_buffer(bufnr)
				end, 1000)
			end,
		})

		-- 插入模式离开时立即保存
		vim.api.nvim_create_autocmd("InsertLeave", {
			group = realtime_group,
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				save_unnamed_buffer(bufnr)
			end,
		})

		-- 缓冲区离开时保存
		vim.api.nvim_create_autocmd("BufLeave", {
			group = realtime_group,
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				save_unnamed_buffer(bufnr)
			end,
		})

		-- 周期性保存会话（每 2 分钟）
		local timer = nil
		local function start_autosave()
			if timer then
				return
			end

			timer = vim.loop.new_timer()
			timer:start(
				120000, -- 2 分钟后首次执行
				120000, -- 之后每 2 分钟执行一次
				vim.schedule_wrap(function()
					-- 静默保存
					save_global_session(true)
				end)
			)
		end

		local function stop_autosave()
			if timer then
				timer:stop()
				timer:close()
				timer = nil
				vim.notify("✓ 已停止自动保存会话", vim.log.levels.INFO)
			end
		end

		-- 启动时开始自动保存
		start_autosave()

		-- 快捷键
		vim.keymap.set("n", "<leader>qs", load_global_session, { desc = "恢复全局 Session" })
		vim.keymap.set("n", "<leader>qw", function()
			save_global_session(false)
		end, { desc = "保存全局 Session" })
		vim.keymap.set("n", "<leader>qd", stop_autosave, { desc = "停止自动保存 Session" })
		vim.keymap.set("n", "<leader>qe", start_autosave, { desc = "启用自动保存 Session" })
		vim.keymap.set("n", "<leader>qc", function()
			-- 清除会话
			if vim.fn.filereadable(global_session) == 1 then
				vim.fn.delete(global_session)
				vim.notify("✓ 全局会话已清除", vim.log.levels.INFO)
			end

			-- 清除未命名文件
			local files = vim.fn.glob(unnamed_dir .. "*", false, true)
			for _, file in ipairs(files) do
				vim.fn.delete(file)
			end
		end, { desc = "清除全局 Session" })
	end,
}
