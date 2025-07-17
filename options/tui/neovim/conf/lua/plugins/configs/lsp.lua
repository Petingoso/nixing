-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local lspconfig = require("lspconfig")



vim.diagnostic.config({
  virtual_text = true,     -- inline message
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "󰌶 ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
    -- Optionally highlight line numbers:
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

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
local servers = { "nil_ls", "clangd", "cssls", "html", "phpactor", "tinymist", "pylsp", "jdtls" }

-- server-specific overrides
local server_overrides = {
	-- tinymist = {
	-- 	settings = {
	-- 		formatterMode = "typstyle",
	-- 	},
	-- },
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

	-- print("Config for " .. lsp_server .. ":")
	-- print(vim.inspect(config))

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
