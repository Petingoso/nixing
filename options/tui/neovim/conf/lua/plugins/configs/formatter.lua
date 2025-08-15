local null_ls = require("null-ls")

-- Define the check function
local function check_formatter_exit_code(code, stderr)
	local success = code <= 0

	if not success then
		vim.schedule(function()
			logger:warn(("failed to run formatter: %s"):format(stderr))
		end)
	end

	return success
end

-- Function to automatically add check_exit_code to normal sources
local function add_check_exit_code_to_sources(sources)
	for _, source in ipairs(sources) do
		if source.with then
			source = source.with({ check_exit_code = check_formatter_exit_code })
		end
	end
	return sources
end

-- Special sources configuration
local special_sources = {
	null_ls.builtins.formatting.clang_format.with({
		extra_args = {
			'--style="{BasedOnStyle: LLVM, '
				.. "AllowShortFunctionsOnASingleLine: All, "
				.. "IndentWidth: 4, "
				.. 'TabWidth: 4}"',
		},
		check_exit_code = check_formatter_exit_code, -- Apply check function
	}),
}

-- Normal sources configuration
local normal_sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.completion.spell,
	null_ls.builtins.formatting.prettierd,
	null_ls.builtins.formatting.alejandra,
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.diagnostics.trail_space,
	null_ls.builtins.formatting.typstyle,
}

-- Automatically apply check_exit_code to all normal sources
normal_sources = add_check_exit_code_to_sources(normal_sources)

-- Setup null-ls with specific formatter configurations
null_ls.setup({
	sources = vim.list_extend(normal_sources, special_sources),
})
