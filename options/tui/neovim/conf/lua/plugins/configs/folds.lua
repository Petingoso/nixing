-- vim.o.foldmethod = "expr"
-- vim.ofoldexpr = "nvim_treesitter#foldexpr()"

vim.o.foldenable = true

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "1"

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

local ufo = require("ufo")

-- vim.fn.sign_define("FoldClosed", { text = "▸", texthl = "Folded" })
-- vim.fn.sign_define("FoldOpen", { text = "▾", texthl = "Folded" })
-- vim.fn.sign_define("FoldSeparator", { text = " ", texthl = "Folded" })

ufo.setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})
