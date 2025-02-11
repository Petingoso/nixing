local tools = {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("plugins.configs.telescope")
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = vim.fn.executable("make") == 1,
	},

	-- formatter config
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("plugins.configs.formatter")
		end,
	},
	-- {
	-- 	"mhartington/formatter.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("plugins.configs.formatter")
	-- 	end,
	-- },

	{ "voldikss/vim-floaterm" }, --toggle term

	-- LSP
	-- Collection of configurations for built-in LSP client

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lsp")
		end,
	},

	{ "onsails/lspkind.nvim" },

	{
		"folke/lsp-colors.nvim",
		config = function()
			require("plugins.configs.lsp-colors")
		end,
	},

	--debugging protocol
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			require("plugins.configs.dap")
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-python").setup("python")
		end,
	},

	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, lazy = true },

	--for tests
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("plugins.configs.neotest")
		end,
	},
	{ "nvim-neotest/neotest-python", event = "VeryLazy", dependencies = "nvim-neotest/neotest" },

	-- Manage external editor tooling i.e LSP servers
	-- {
	-- 	"williamboman/mason.nvim",
	-- 	config = function()
	-- 		require("plugins.configs.mason")
	-- 	end,
	-- },
	-- { "williamboman/mason-lspconfig.nvim" }, -- Automatically install language servers to stdpath
	-- { "jay-babu/mason-nvim-dap.nvim" }, --mason for dap

	--markdown previewing
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{ "lervag/vimtex" }, --latex completion and previewing

	{ "lervag/wiki.vim" }, --vim wiki, markdown collection
	{ "alvan/vim-closetag" }, --close html tags
	{ "dfendr/clipboard-image.nvim" }, --:PasteImg to paste an image
	{ "ibhagwan/smartyank.nvim" }, --better yank
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{
		"ray-x/web-tools.nvim",
		config = function()
			require("plugins.configs.web-tools")
		end,
	}, -- Browser Sync and the sort

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "InsertEnter",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		config = function()
			require("CopilotChat").setup()
		end,
	}, -- for asking copilot
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		opts = {
			dependencies_bin = {
				["tinymist"] = "tinymist",
			},
		},
		config = function()
			require("typst-preview").setup()
		end,
	},
}

return tools
