local map = vim.keymap.set
vim.g.mapleader = " "

map("n", "<leader>T", "<cmd>ThemeSwitch theme=dropdown<cr>", { silent = true, desc = "主题切换" })

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 智能保存：未命名文件提示输入文件名
map({ "i", "n", "v", "s" }, "<C-s>", function()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		-- 未命名文件，提示输入文件名
		vim.ui.input({ prompt = "保存为: " }, function(filename)
			if filename and filename ~= "" then
				vim.cmd("write " .. filename)
			end
		end)
	else
		-- 已命名文件，直接保存
		vim.cmd("write")
	end
end, { desc = "保存文件" })
map({ "i", "n" }, "<C-a>", "<Cmd>normal! ggVG<CR>", { silent = true, desc = "全选操作" })

map("n", "<leader>qq", "<cmd>wqa<cr>", { desc = "退出编辑器" })

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "增加窗户高度" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "减少窗户高度" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "增加窗户宽度" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "减少窗户宽度" })

map("n", "<leader>wH", "<C-w>H", { silent = true, desc = "窗口移到左边" })
map("n", "<leader>wJ", "<C-w>J", { silent = true, desc = "窗口移到底部" })
map("n", "<leader>wK", "<C-w>K", { silent = true, desc = "窗口移到底部" })
map("n", "<leader>wL", "<C-w>L", { silent = true, desc = "窗口移到右边" })

-- 行移动
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

map("n", "<leader><tab><tab>", "<cmd>tabnew<CR>", { desc = "新建标签页" })
map("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "关闭当前标签页" })
map("n", "<leader><tab>o", "<cmd>tabonly<CR>", { desc = "关闭其他标签页" })
map("n", "<leader><tab>l", "<cmd>tabnext<CR>", { desc = "切换到下一个标签页" })
map("n", "<leader><tab>h", "<cmd>tabprevious<CR>", { desc = "切换到上一个标签页" })

-- Sublime Text 风格快捷键
-- 新建空白文件（保存时再命名）
map("n", "<C-n>", "<cmd>enew<CR>", { desc = "新建文件" })

-- 智能关闭：未保存的文件提示保存
map("n", "<C-w>", function()
	local buf = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(buf, "modified")
	local bufname = vim.api.nvim_buf_get_name(buf)

	if modified then
		if bufname == "" then
			-- 未命名且有修改，提示是否保存
			vim.ui.select({ "保存", "不保存", "取消" }, {
				prompt = "未命名文件有未保存的修改:",
			}, function(choice)
				if choice == "保存" then
					vim.ui.input({ prompt = "保存为: " }, function(filename)
						if filename and filename ~= "" then
							vim.cmd("write " .. filename)
							vim.cmd("bdelete")
						end
					end)
				elseif choice == "不保存" then
					vim.cmd("bdelete!")
				end
			end)
		else
			-- 有文件名但未保存，使用默认行为（Vim 会提示）
			vim.cmd("bdelete")
		end
	else
		vim.cmd("bdelete")
	end
end, { desc = "关闭当前缓冲区" })

map("n", "<C-Tab>", "<cmd>bnext<CR>", { desc = "下一个缓冲区" })
map("n", "<C-S-Tab>", "<cmd>bprevious<CR>", { desc = "上一个缓冲区" })

-- 切换换行显示
map("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	if vim.wo.wrap then
		vim.wo.linebreak = true -- 启用智能换行（不在单词中间换行）
		vim.notify("已启用自动换行", vim.log.levels.INFO)
	else
		vim.notify("已禁用自动换行", vim.log.levels.INFO)
	end
end, { desc = "切换自动换行" })

-- 更好的粘贴支持 - 从系统剪贴板粘贴
map("n", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴(后)" })
map("n", "<leader>P", '"+P', { desc = "从系统剪贴板粘贴(前)" })
map("v", "<leader>p", '"+p', { desc = "从系统剪贴板粘贴" })
-- 插入模式下使用 Ctrl+V 粘贴（不会有转义字符）
map("i", "<C-v>", "<C-r>+", { desc = "粘贴系统剪贴板" })

-- 清理当前行的转义序列
map("n", "<leader>uc", function()
	local line = vim.api.nvim_get_current_line()
	-- 移除常见的转义序列
	local cleaned = line:gsub("%[%d+;%d+;%d+~", "\n") -- 替换 [27;5;106~ 为换行
	cleaned = cleaned:gsub("%[%d+~", "") -- 移除其他转义序列
	cleaned = cleaned:gsub("", "") -- 移除 ESC 字符
	vim.api.nvim_set_current_line(cleaned)
	vim.notify("已清理转义序列", vim.log.levels.INFO)
end, { desc = "清理当前行转义序列" })

-- 清理选中文本的转义序列
map("v", "<leader>uc", function()
	-- 获取选中的范围
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local start_line = start_pos[2]
	local end_line = end_pos[2]

	-- 获取并清理所有选中的行
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	for i, line in ipairs(lines) do
		-- 替换转义序列为实际内容
		lines[i] = line:gsub("%[27;5;106~", "\n") -- Ctrl+j -> 换行
		lines[i] = lines[i]:gsub("%[%d+;%d+;%d+~", "") -- 其他序列
		lines[i] = lines[i]:gsub("%[%d+~", "")
		lines[i] = lines[i]:gsub("", "")
	end

	-- 分割包含换行符的行
	local new_lines = {}
	for _, line in ipairs(lines) do
		for subline in line:gmatch("[^\n]+") do
			table.insert(new_lines, subline)
		end
	end

	-- 替换原来的行
	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
	vim.notify("已清理并分割文本", vim.log.levels.INFO)
end, { desc = "清理选中文本转义序列" })
