return {
    {
        "github/copilot.vim",
		event = "VeryLazy",
        config = function()
			vim.g.copilot_filetypes = {
				["TelescopePrompt"] = false,
			}

			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true

			vim.keymap.set(
				"i", "<C-j>", 'copilot#Accept("\\<CR>")',
				{ expr = true, replace_keycodes = false }
			)
        end
    },
}
