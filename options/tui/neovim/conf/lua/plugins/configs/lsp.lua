-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local lspconfig = require("lspconfig")

local on_attach = function(_, bufnr)
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.

	-- Change diagnostic symbols in the gutter
	local signs = { Error = "󰅚 ", Warn = " ", Hint = "󰌶 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

local servers = { "nil_ls", "clangd", "cssls", "html"}
for _, lsp_server in ipairs(servers) do
	lspconfig[lsp_server].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {},
	})
end

lspconfig.jedi_language_server.setup({})
lspconfig.phpactor.setup({
	root_dir = function(fname)
		return require("lspconfig/util").find_git_ancestor(fname) or vim.fn.getcwd()
	end,
})

-- nvim-cmp supports additional completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

