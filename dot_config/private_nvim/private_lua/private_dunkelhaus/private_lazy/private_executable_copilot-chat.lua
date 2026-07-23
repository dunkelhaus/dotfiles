return {
	-- Sidekick replaces CopilotChat. Keep Copilot inline completions via copilot-vim.
	{ import = "dunkelhaus.lazy.copilot-vim" },
	{ import = "dunkelhaus.lazy.sidekick" },
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>a", group = "ai" },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown" },
		},
		ft = { "markdown" },
	},
}
