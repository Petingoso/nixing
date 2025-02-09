local formatter = require("formatter")
local util = require("formatter.util")

local prettierConfig = function()
	return {
		exe = "prettierd",
		args = { vim.api.nvim_buf_get_name(0) },
		stdin = true,
	}
end

local ClangConfig = function()
	return {
		exe = "clang-format",
		args = {
			"--assume-filename",
			util.escape_path(util.get_current_buffer_file_name()),
			'--style="{BasedOnStyle: LLVM, AllowShortFunctionsOnASingleLine : All, IndentWidth: 4, TabWidth: 4, }"',
		},
		stdin = true,
		try_node_modules = true,
	}
end

local formatterConfig = {
	lua = require("formatter.filetypes.lua").stylua,

	nix = require("formatter.filetypes.nix").alejandra,

	typst = {
		function()
			return {
				exe = "typstyle",
			}
		end,
	},
	sh = {
		function()
			return {
				exe = "beautysh",
				args = { "-t" },
			}
		end,
	},
	["*"] = {
		require("formatter.filetypes.any").remove_trailing_whitespace,
		--(https://github.com/mhartington/formatter.nvim/issues/260#issuecomment-1676039290)
		function()
			local defined_types = require("formatter.config").values.filetype
			if defined_types[vim.bo.filetype] ~= nil then
				return nil
			end
			vim.lsp.buf.format({ async = true })
		end,
	},
}
local commonFT = {
	"css",
	"scss",
	"html",
	"java",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"markdown",
	"markdown.mdx",
	"json",
	"yaml",
	"xml",
	"svg",
	"svelte",
}

local C_type = {
	"c",
	"cpp",
}

for _, ft in ipairs(commonFT) do
	formatterConfig[ft] = { prettierConfig }
end

for _, ft in ipairs(C_type) do
	formatterConfig[ft] = { ClangConfig }
end
-- Setup functions
formatter.setup({
	logging = true,
	filetype = formatterConfig,
	log_level = 2,
})
