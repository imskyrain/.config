-- 全局 Session 管理（Sublime Text 风格）
-- 独立配置，不依赖任何插件
-- 已禁用，使用 persistence.nvim 代替
return {
	-- 使用 lazy.nvim 的 init 模式，无需加载实际插件
	dir = vim.fn.stdpath("config"),
	name = "global-session",
	enabled = false, -- 禁用，改用 persistence.nvim
	lazy = false,
	priority = 100,
	config = function()
		-- 全局 session 文件路径
		local session_dir = vim.fn.stdpath("state") .. "/sessions/"
		local global_session = session_dir .. "global.vim"

		-- 确保 session 目录存在
		vim.fn.mkdir(session_dir, "p")

		-- Session 配置（支持空 buffer）
		vim.opt.sessionoptions = {
			"buffers",
			"curdir",
			"tabpages",
			"winsize",
			"help",
			"globals",
			"skiprtp",
			"folds",
			"blank", -- 支持未命名的空 buffer
		}

		-- 自动保存全局 session
		local function save_global_session()
			-- 保存当前 session
			vim.cmd("mksession! " .. global_session)
		end

		-- 自动加载全局 session
		local function load_global_session()
			if vim.fn.filereadable(global_session) == 1 then
				vim.cmd("silent! source " .. global_session)
			end
		end

		-- VimEnter: 自动恢复 session（仅在无参数启动时）
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("global_session", { clear = true }),
			callback = function()
				if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
					load_global_session()
				end
			end,
			nested = true,
		})

		-- VimLeavePre: 退出时自动保存 session
		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = vim.api.nvim_create_augroup("global_session_save", { clear = true }),
			callback = save_global_session,
		})

		-- 手动管理快捷键
		vim.keymap.set("n", "<leader>qs", load_global_session, { desc = "恢复全局 Session" })
		vim.keymap.set("n", "<leader>qw", save_global_session, { desc = "保存全局 Session" })
		vim.keymap.set("n", "<leader>qd", function()
			-- 删除 autocmd 来禁用自动保存
			vim.api.nvim_clear_autocmds({ group = "global_session_save" })
			vim.notify("已停止自动保存 Session", vim.log.levels.INFO)
		end, { desc = "停止自动保存 Session" })
	end,
}
