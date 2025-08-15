require("neotest").setup({
	adapters = {
		require("neotest-python"),
	},
	config = {
		discovery = {
			enabled = true,
			concurrent = 1,
		},
	},
})
