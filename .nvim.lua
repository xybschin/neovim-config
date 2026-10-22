-- ┌──────────────────────────────┐
-- │ Project-local Neovim config  │
-- └──────────────────────────────┘
--
-- Language servers are enabled per project instead of globally. See
-- ':h project-config' and ':h 'exrc''.
--
-- This repository contains Lua code, so enable 'lua_ls' for it.
--
-- NOTE: this file has to be trusted before it is executed. Run ':trust' on it
-- once. Trust is based on the file contents, so it is needed again after
-- every edit (see ':h trust').

vim.lsp.enable({ "lua_ls" })

-- Project-specific settings. A 'vim.lsp.config()' call has the highest
-- priority, so these are merged on top of the global 'after/lsp/lua_ls.lua'.
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			-- 'vim' is Neovim's global API namespace.
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Formatters are configured per project as well. The global setup in
-- 'plugin/40_plugins.lua' does not set any formatter, so this is the only
-- place where they are defined.
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
})
