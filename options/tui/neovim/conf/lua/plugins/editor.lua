local editor = {
	--remember buffer location
	{
		"vladdoster/remember.nvim",
		config = function()
			require("remember")
		end,
	},

	--cool movement, use sChar1Char2[Char3]
	{
		"https://codeberg.org/andyg/leap.nvim",
		event = "BufEnter",
		config = function()
			require("plugins.configs.leap")
		end,
	},

	--"gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		event = "BufEnter",
		config = function()
			require("plugins.configs.comment")
		end,
	},

	--move lines easier
	{
		"booperlv/nvim-gomove",
		event = "BufEnter",
		config = function()
			require("plugins.configs.gomove")
		end,
	},

	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true}, --auto pair
	{ "tpope/vim-surround", event = "VeryLazy" }, -- change surrounding symbols ez "a"->(a)

	--better marks
	{
		"chentoast/marks.nvim",
		event = "BufEnter",
		config = function()
			require("plugins.configs.marks")
		end,
	},

	-- CMP and completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-omni",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"f3fora/cmp-spell",
		},
		event = "InsertEnter",
		config = function()
			require("plugins.configs.cmp")
		end,
	},

	--get from other kitty windows
	{
		"garyhurtz/cmp_kitty",
		event = "InsertEnter";
		init = function()
			require("cmp_kitty").setup()
		end,
	},

	-- Snippet Engine and Snippet Expansion
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
		config = function()
			require("plugins.configs.luasnip")
		end,
	},

	{ "sedm0784/vim-you-autocorrect",event = "VeryLazy" }, --autocorrect with spell
}

return editor
