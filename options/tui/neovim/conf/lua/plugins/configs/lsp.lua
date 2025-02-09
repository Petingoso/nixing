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

local function which_python()
	local f = io.popen("env which python", "r") or error("Fail to execute 'env which python'")
	local s = f:read("*a") or error("Fail to read from io.popen result")
	f:close()
	return string.gsub(s, "%s+$", "")
end

-- nvim-cmp supports additional completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- generic config
local servers = { "nil_ls", "clangd", "cssls", "html", "phpactor", "tinymist", "pylsp" }

-- server-specific overrides
local server_overrides = {
	pylsp = {
		settings = {
			exportPdf = "onType",
			outputPath = "$root/target/$dir/$name",
		},
	},
}

for _, lsp_server in ipairs(servers) do
	local config = {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {},
	}

	-- Apply server-specific overrides if they exist
	if server_overrides[lsp_server] then
		for k, v in pairs(server_overrides[lsp_server]) do
			config[k] = v
		end
	end

	lspconfig[lsp_server].setup(config)
end

-- for servers with bad root_dir functions
local function setup_root(server)
	lspconfig[server].setup({
		root_dir = function(fname)
			return require("lspconfig/util").find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	})
end

setup_root("phpactor")
setup_root("tinymist")
