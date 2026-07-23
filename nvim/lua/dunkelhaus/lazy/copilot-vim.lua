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


			vim.keymap.set("i", "<C-j>", function()
				local ok, sidekick = pcall(require, "sidekick")
				if ok and sidekick.nes_jump_or_apply and sidekick.nes_jump_or_apply() then
					return ""
				end

				return vim.fn["copilot#Accept"]("\\<CR>")
			end, { expr = true, replace_keycodes = false })
		end
	},
}
