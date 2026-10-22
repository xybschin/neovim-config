-- ┌──────────────────────────────┐
-- │ Project-local configuration  │
-- └──────────────────────────────┘
--
-- Language servers are enabled per project instead of globally. To do so, put
-- a project config file in the project root:
--
-- - '.nvim.lua' - Lua code (recommended)
-- - '.nvimrc'   - Vimscript code
--
-- Example content of '.nvim.lua':
--
--   vim.lsp.enable({ "gopls" })
--
-- Neovim's built-in 'exrc' mechanism sources such files found in the current
-- directory and its parents (see `:h 'exrc'`, `:h project-config`). This file
-- additionally loads the config of the project that the opened file belongs
-- to. This makes it work also when Neovim is started outside of the project.
--
-- Project-specific server *settings* can be provided with 'lsp/<name>.lua'
-- files inside the project (see `:h lsp-new-config`). To make them visible,
-- add the following line to the project config file:
--
--   vim.cmd([[set runtimepath+=.nvim]])
--
-- NOTE: a project config file has to be trusted before it is executed. Run
-- `:trust` on it once. Note that trust is based on file contents, so it has to
-- be repeated after every edit (see `:h trust`, `:h vim.secure.read()`).

-- Config files that were already sourced.
local sourced = {}

-- Mark config files handled by the built-in 'exrc' mechanism as sourced. It
-- uses the same lookup, so this avoids executing them twice.
for _, file in
	ipairs(vim.fs.find({ ".nvim.lua", ".nvimrc", ".exrc" }, {
		type = "file",
		upward = true,
		limit = math.huge,
	}))
do
	sourced[file] = true
end

-- Source a project config file. Trust is checked with 'vim.secure.read()'.
local source_config = function(file)
	if sourced[file] then
		return
	end
	sourced[file] = true

	local contents = vim.secure.read(file)
	if not contents then
		return
	end

	if vim.endswith(file, ".lua") then
		assert(loadstring(contents, "@" .. file))()
	else
		vim.api.nvim_exec2(contents, {})
	end
end

-- Load config of the project the file in the buffer belongs to.
Config.new_autocmd("FileType", nil, function(ev)
	local fname = vim.api.nvim_buf_get_name(ev.buf)
	if fname == "" then
		return
	end
	local root = vim.fs.root(fname, { ".nvim.lua", ".nvimrc" })
	if not root then
		return
	end
	for _, name in ipairs({ ".nvim.lua", ".nvimrc" }) do
		local file = vim.fs.joinpath(root, name)
		if vim.uv.fs_stat(file) then
			source_config(file)
		end
	end
end)
