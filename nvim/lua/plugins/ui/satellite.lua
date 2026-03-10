-- 代码小地图 - 类似 Sublime Text 的右侧预览（真正的代码缩略图）
return {
	"gorbit99/codewindow.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local codewindow = require("codewindow")
		codewindow.setup({
			auto_enable = true, -- 自动启用小地图
			exclude_filetypes = {
				"neo-tree",
				"NeoTree",
				"aerial",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"alpha",
				"help",
			},
			max_minimap_height = nil, -- 最大高度（nil = 无限制）
			max_lines = nil, -- 最大行数（nil = 无限制）
			minimap_width = 20, -- 小地图宽度
			use_lsp = true, -- 使用 LSP 高亮
			use_treesitter = true, -- 使用 treesitter 高亮
			use_git = true, -- 显示 git 状态
			width_multiplier = 4, -- 宽度倍数
			z_index = 1, -- 窗口层级
			show_cursor = true, -- 显示光标位置
			screen_bounds = "background", -- 或 "lines"
			window_border = "none", -- 边框样式: 'none', 'single', 'double'
		})

		-- 应用自定义高亮（可选）
		codewindow.apply_default_keybinds()
	end,
	keys = {
		{
			"<leader>mm",
			function()
				require("codewindow").toggle_minimap()
			end,
			desc = "切换代码小地图",
		},
		{
			"<leader>mf",
			function()
				require("codewindow").toggle_focus()
			end,
			desc = "聚焦/取消聚焦小地图",
		},
	},
}
