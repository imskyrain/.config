-- Auto Session - 自动会话管理（Sublime Text 风格）
return {
	"rmagatti/auto-session",
	lazy = false,
	opts = {
		log_level = "error",
		auto_session_enabled = true,
		auto_save_enabled = true,
		auto_restore_enabled = true,
		auto_session_suppress_dirs = { "~/", "~/Downloads", "/tmp" },
		auto_session_use_git_branch = false,

		-- Session 选项
		session_lens = {
			load_on_setup = true,
			theme_conf = { border = true },
			previewer = false,
		},

		-- 自动保存前的回调
		pre_save_cmds = {
			-- 在保存前关闭某些特殊类型的窗口
			function()
				-- 关闭所有浮动窗口
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local config = vim.api.nvim_win_get_config(win)
					if config.relative ~= "" then
						vim.api.nvim_win_close(win, false)
					end
				end
			end,
		},
	},
	keys = {
		{ "<leader>qs", "<cmd>SessionSearch<cr>", desc = "搜索 Session" },
		{ "<leader>qw", "<cmd>SessionSave<cr>", desc = "保存 Session" },
		{ "<leader>qr", "<cmd>SessionRestore<cr>", desc = "恢复 Session" },
		{ "<leader>qd", "<cmd>SessionDelete<cr>", desc = "删除 Session" },
		{ "<leader>qt", "<cmd>SessionDisableAutoSave<cr>", desc = "禁用自动保存" },
		{ "<leader>qe", "<cmd>SessionToggleAutoSave<cr>", desc = "切换自动保存" },
	},
}
