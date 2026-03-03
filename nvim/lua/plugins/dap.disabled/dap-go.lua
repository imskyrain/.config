return {
	"leoluz/nvim-dap-go",
	dependencies = { "mfussenegger/nvim-dap" },
	ft = "go",
	config = function()
		require("dap-go").setup({
			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			},
			delve = {
				path = "dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
				args = {},
				build_flags = "",
			},
		})
	end,
}
