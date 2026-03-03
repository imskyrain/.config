return {
	"mfussenegger/nvim-dap-python",
	dependencies = { "mfussenegger/nvim-dap" },
	ft = "python",
	config = function()
		local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
		require("dap-python").setup(path)
	end,
}
