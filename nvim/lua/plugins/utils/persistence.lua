-- Persistence.nvim - Session 管理（Sublime Text 风格）
-- 已禁用，使用 auto-session 代替
return {
	"folke/persistence.nvim",
	enabled = false, -- 禁用，改用 auto-session
	event = "BufReadPre",
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/",
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
	},
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "恢复 Session",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "恢复上次 Session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "停止保存 Session",
		},
	},
}
