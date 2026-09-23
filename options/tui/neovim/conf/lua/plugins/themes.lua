local themes = {
	-- Themes
	-- { "catppuccin/nvim", name = "catppuccin" },
	-- { "rose-pine/neovim" },
	-- { "shaunsingh/nord.nvim" },
	-- { "folke/tokyonight.nvim" },
	-- { "ericbn/vim-solarized" },
	-- { "ellisonleao/gruvbox.nvim" },
	-- { "sainnhe/everforest" },
	-- { "roosta/srcery" },
	--
	{ "xiyaowong/nvim-transparent" },
	{
		"RRethy/base16-nvim",
		config = function()
			require("plugins.configs.theme")
		end,
	},
}

return themes
