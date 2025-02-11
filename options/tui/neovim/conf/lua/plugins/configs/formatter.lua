local null_ls = require("null-ls")

local special_sources = {
	null_ls.builtins.formatting.clang_format.with({
		extra_args = {
			'--style="{BasedOnStyle: LLVM, '
				.. "AllowShortFunctionsOnASingleLine: All, "
				.. "IndentWidth: 4, "
				.. 'TabWidth: 4}"',
		},
	}),
}

local normal_sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.completion.spell,
	null_ls.builtins.formatting.prettierd,
	null_ls.builtins.formatting.alejandra,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.diagnostics.trail_space,
	null_ls.builtins.formatting.typstyle,
}

local sources = vim.list_extend(normal_sources, special_sources)

null_ls.setup({ sources = sources })
