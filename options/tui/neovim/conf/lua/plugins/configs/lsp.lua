-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local lspconfig = vim.lsp

vim.diagnostic.config({
	virtual_text = true, -- inline message
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
		-- Optionally highlight line numbers:
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

local function which_python()
	local f = io.popen("env which python", "r")
	if not f then
		error("Fail to execute 'env which python'")
	end
	local s = f:read("*a")
	f:close()
	if not s then
		error("Fail to read from io.popen result")
	end
	return string.gsub(s, "%s+$", "")
end

-- nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities(lspconfig.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- List of servers you want to enable via default config
local servers = { "nil_ls", "ccls", "cssls", "html", "phpactor", "tinymist", "pylsp", "java_language_server", "rust_analyzer"}

-- Overrides per-server
--
local server_overrides = {
	["java_language_server"] = {
		cmd = { "java-language-server"}
	}
-- 	-- e.g. tinymist = { settings = { formatterMode = "typstyle" } },
}

for _, lsp_server in ipairs(servers) do
	local config = {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {},
	}

	-- apply overrides
	local override = server_overrides[lsp_server]
	if override then
		for k, v in pairs(override) do
			config[k] = v
		end
	end

	lspconfig.config(lsp_server, config)
	lspconfig.enable(lsp_server)
end

-- For servers whose default root logic is “bad”, override it:
local function setup_root(server)
	lspconfig.config(server, {
		root_markers = { ".git" },

		-- define root_dir function to override default behavior
		root_dir = function(bufnr, on_dir)
			local name = vim.api.nvim_buf_get_name(bufnr)
			-- Try root_pattern via the built‑in util
			local root_patterns = { ".git" }
			local marker_root = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
			if marker_root then
				on_dir(marker_root)
			else
				on_dir(vim.fn.getcwd())
			end
		end,
	})
	lspconfig.enable(server)
end

setup_root("phpactor")
setup_root("tinymist")
