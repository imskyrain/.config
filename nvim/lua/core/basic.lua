--行号
vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号
vim.opt.signcolumn = "yes" -- 永远显示 sign column（诊断标记）
vim.opt.winborder = "rounded" -- 边框样式
-- Session 选项已移至 persistence.lua 中统一管理
-- vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds", "blank" }
--换行统一
-- 设置文件默认保存格式为 Unix (LF)
vim.opt.fileformat = "unix"
-- 设置文件格式检测优先级，Unix 优先
vim.opt.fileformats = { "unix", "dos", "mac" }

-- 搜索
vim.opt.ignorecase = true -- 搜索忽略大小写
vim.opt.smartcase = true -- 如果包含大写字符，则区分大小写
vim.opt.hlsearch = false -- 搜索匹配不高亮
vim.opt.incsearch = true -- 增量搜索

--换行缩进
vim.opt.tabstop = 2 -- Tab 长度为 4
vim.opt.shiftwidth = 2 -- 缩进长度为 4
vim.opt.expandtab = true -- 将 Tab 替换为空格
vim.opt.autoindent = true -- 复制当前行的缩进
vim.opt.smartindent = true -- 在代码块中自动增加缩进
vim.opt.wrap = false -- 不换行显示
vim.opt.colorcolumn = { "80", "120" }
vim.opt.cursorline = true -- 启动光标行高亮

vim.o.termguicolors = true -- 真色彩Alacritty，kitty，iTerm2 (macOS)，Windows Terminal (Windows 10/11)等
vim.opt.laststatus = 0 -- 禁用底部状态栏

-- Tmux 特殊配置
if vim.env.TMUX then
	-- 在 tmux 中配置剪贴板集成
	-- 使用 OSC 52 序列直接与系统剪贴板通信
	vim.g.clipboard = {
		name = "tmux-osc52",
		copy = {
			["+"] = { "tmux", "load-buffer", "-w", "-" },
			["*"] = { "tmux", "load-buffer", "-w", "-" },
		},
		paste = {
			["+"] = { "bash", "-c", 'tmux save-buffer - 2>/dev/null || pbpaste' },
			["*"] = { "bash", "-c", 'tmux save-buffer - 2>/dev/null || pbpaste' },
		},
		cache_enabled = 0,
	}
end

-- 光标位置
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- 功能
vim.opt.undofile = true -- 启用持久撤销
vim.opt.clipboard = "unnamedplus" -- 共享系统剪切板
vim.opt.mouse = "a" -- 启用鼠标支持
vim.opt.swapfile = false -- 禁用交换文件
vim.opt.backup = false -- 禁用备份文件
vim.opt.writebackup = false -- 禁用写入前备份

-- Sublime Text 风格设置
vim.opt.hidden = true -- 允许在未保存的缓冲区之间切换
vim.opt.confirm = true -- 退出时提示保存未保存的文件
vim.opt.autoread = true -- 文件在外部修改时自动重新读取
vim.opt.updatetime = 300 -- 更快的 CursorHold 事件触发

-- 更平滑的滚动
vim.opt.smoothscroll = true

-- 代码折叠 (使用uof.lua的那一套配置)
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false -- 打开文件时不自动折叠
-- vim.opt.foldlevelstart = 99 -- 默认展开所有

-- 首行作为默认文件名 (Sublime Text 风格) - 改进版
local used_first_line_for_filename = false

local function get_first_line_as_filename()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
	if #lines > 0 and lines[1] ~= "" then
		local first_line = lines[1]:match("^%s*(.-)%s*$") -- 去除首尾空格
		if first_line ~= "" then
			-- 清理文件名，保留合法字符，限制长度
			local filename = first_line:sub(1, 100) -- 限制最大长度
			filename = filename:gsub('[<>:"/\\|?*]', "_") -- 替换非法字符
			filename = filename:gsub("_+", "_") -- 合并多个下划线
			filename = filename:gsub("^_+", ""):gsub("_+$", "") -- 去除首尾下划线

			-- 如果没有扩展名，尝试根据文件类型添加
			if not filename:match("%.%w+$") then
				local ft = vim.bo.filetype
				if ft == "python" then
					filename = filename .. ".py"
				elseif ft == "javascript" or ft == "javascriptreact" then
					filename = filename .. ".js"
				elseif ft == "typescript" or ft == "typescriptreact" then
					filename = filename .. ".ts"
				elseif ft == "lua" then
					filename = filename .. ".lua"
				elseif ft == "markdown" then
					filename = filename .. ".md"
				elseif ft ~= "" then
					filename = filename .. ".txt"
				end
			end

			return filename
		end
	end
	return nil
end

local function save_with_first_line_name()
	local bufname = vim.api.nvim_buf_get_name(0)

	-- 如果文件已命名，直接保存
	if bufname ~= "" then
		vim.cmd("write")
		return
	end

	-- 尝试使用首行作为文件名
	local filename = get_first_line_as_filename()
	if filename then
		vim.ui.input({
			prompt = "保存为: ",
			default = filename,
		}, function(input)
			if input and input ~= "" then
				local success, err = pcall(function()
					vim.cmd("write " .. vim.fn.fnameescape(input))
				end)
				if success then
					used_first_line_for_filename = true
					-- 保存成功后删除首行
					vim.schedule(function()
						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						if #lines > 1 then
							vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
							vim.cmd("write")
						end
					end)
				else
					vim.notify("保存失败: " .. tostring(err), vim.log.levels.ERROR)
				end
			end
		end)
	else
		-- 没有首行，提示输入文件名
		vim.ui.input({ prompt = "保存为: " }, function(input)
			if input and input ~= "" then
				vim.cmd("write " .. vim.fn.fnameescape(input))
			end
		end)
	end
end

vim.keymap.set("n", "<leader>ws", save_with_first_line_name, { noremap = true, silent = true, desc = "保存并以首行为文件名" })

-- 修改文件名
local function rename_file()
	local buf = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(buf)

	if bufname == "" then
		vim.notify("未命名的缓冲区，请先保存", vim.log.levels.WARN)
		return
	end

	local dir = vim.fn.fnamemodify(bufname, ":p:h")
	local old_name = vim.fn.fnamemodify(bufname, ":t")
	vim.ui.input({
		prompt = "新文件名: ",
		default = old_name,
	}, function(new_name)
		if new_name and new_name ~= "" and new_name ~= old_name then
			local new_path = dir .. "/" .. new_name
			vim.cmd("saveas " .. vim.fn.fnameescape(new_path))
			vim.fn.delete(bufname) -- 删除旧文件
			vim.notify("文件已重命名: " .. new_name, vim.log.levels.INFO)
		end
	end)
end

vim.keymap.set("n", "<leader>rn", rename_file, { noremap = true, silent = true, desc = "重命名文件" })

-- 背景透明设置（与终端保持一致）
local function set_transparent_background()
	vim.cmd([[
		hi Normal guibg=NONE ctermbg=NONE
		hi NormalNC guibg=NONE ctermbg=NONE
		hi SignColumn guibg=NONE ctermbg=NONE
		hi NormalFloat guibg=NONE ctermbg=NONE
		hi FloatBorder guibg=NONE ctermbg=NONE
		hi Pmenu guibg=NONE ctermbg=NONE
		hi EndOfBuffer guibg=NONE ctermbg=NONE
		hi LineNr guibg=NONE ctermbg=NONE
		hi CursorLineNr guibg=NONE ctermbg=NONE
	]])
end

-- 立即应用透明背景
set_transparent_background()

-- 主题切换后重新应用透明背景
vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "主题切换后保持背景透明",
	group = vim.api.nvim_create_augroup("transparent-bg", { clear = true }),
	callback = function()
		set_transparent_background()
	end,
})
