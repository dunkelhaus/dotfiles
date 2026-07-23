return {
	{
		"folke/sidekick.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			cli = {
				-- Enable window vs mux.
				-- win = {
				-- 	layout = "right",
				-- 	split = {
				-- 		width = 80,
				-- 		height = 20,
				-- 	},
				-- },
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		config = function(_, opts)
			require("sidekick").setup(opts)
		end,
		keys = {
			-- Integrated CLI
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ name = "opencode", focus = true })
				end,
				desc = "Sidekick - Toggle OpenCode CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				desc = "Sidekick - Select CLI",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick - Select prompt",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Sidekick - Send file",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Sidekick - Send selection",
			},
			{
				"<leader>ac",
				function()
					require("sidekick.cli").focus()
				end,
				desc = "Sidekick - Focus CLI when open",
			},
		},
	},
}
