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
-- 智能新建文件：立即提示输入文件名
map("n", "<C-n>", function()
	vim.ui.input({ prompt = "新建文件: " }, function(filename)
		if filename and filename ~= "" then
			vim.cmd("edit " .. filename)
		end
	end)
end, { desc = "新建文件" })

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
