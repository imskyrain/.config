--行号
vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号
vim.opt.signcolumn = "yes" -- 永远显示 sign column（诊断标记）
vim.opt.winborder = "rounded" -- 边框样式
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
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
