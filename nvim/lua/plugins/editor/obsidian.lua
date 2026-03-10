return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "vault",
				path = "~/Documents/Obsidian Vault",
			},
			{
				name = "mobile",
				path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents",
			},
		},

		-- 笔记路径配置
		notes_subdir = "",
		new_notes_location = "current_dir",

		-- 日记配置
		daily_notes = {
			folder = "Daily",
			date_format = "%Y-%m-%d",
			template = nil,
		},

		-- 笔记命名规则
		note_id_func = function(title)
			-- 如果有标题，使用标题作为文件名
			if title ~= nil then
				return title
			else
				-- 否则使用时间戳
				return tostring(os.time())
			end
		end,

		-- Wiki 链接配置
		wiki_link_func = function(opts)
			return string.format("[[%s]]", opts.label)
		end,

		-- 模板配置
		templates = {
			folder = "Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		-- 补全配置
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},

		-- 映射配置
		mappings = {
			-- 跟随链接
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- 切换复选框
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},

		-- 禁用某些功能（如果你有其他插件处理）
		disable_frontmatter = false,

		-- UI 配置
		ui = {
			enable = true,
			update_debounce = 200,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			hl_groups = {
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},

		-- 附件配置
		attachments = {
			img_folder = "assets/imgs",
		},
	},

	config = function(_, opts)
		require("obsidian").setup(opts)

		-- 自定义命令和快捷键
		local keymap = vim.keymap.set

		-- Obsidian 相关快捷键
		keymap("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "新建笔记" })
		keymap("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "在 Obsidian 中打开" })
		keymap("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "搜索笔记" })
		keymap("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "快速切换笔记" })
		keymap("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "显示反向链接" })
		keymap("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "打开今日笔记" })
		keymap("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "打开昨日笔记" })
		keymap("n", "<leader>ol", "<cmd>ObsidianLinks<cr>", { desc = "显示链接" })
		keymap("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = "切换工作区" })
		keymap("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "粘贴图片" })
		keymap("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "重命名笔记" })
		keymap("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "创建链接" })
		keymap("v", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "创建新笔记链接" })
	end,
}
