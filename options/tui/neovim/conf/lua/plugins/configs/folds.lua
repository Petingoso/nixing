-- vim.o.foldmethod = "expr"
-- vim.ofoldexpr = "nvim_treesitter#foldexpr()"

vim.o.foldenable = true

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "1"

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

local ufo = require("ufo")

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set("n", "K", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end)

ufo.setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})
