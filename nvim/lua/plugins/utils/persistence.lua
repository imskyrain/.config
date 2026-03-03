return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
		need = 1, -- 至少一个文件缓冲区才保存 session
		branch = true, -- use git branch to save session
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
	init = function()
		-- 自动恢复 session（仿 Sublime Text）
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
			callback = function()
				-- 只在没有传入文件参数且不是 Git 提交时自动恢复
				if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
					require("persistence").load()
				end
			end,
			nested = true,
		})
	end,
}
