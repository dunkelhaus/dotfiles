return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/nvim-nio",
			{ "fredrikaverpil/neotest-golang", version = "*" },
		},
		opts = function(_, opts)
			opts.adapters = opts.adapters or {}
			opts.adapters["neotest-golang"] = {
				go_test_args = { "-v", "-gcflags='-N -l'" },
			}
		end,
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-vitest"),
					require("neotest-golang"),
					require("neotest-plenary").setup({
						-- this is my standard location for minimal vim rc
						-- in all my projects
						min_init = "./scripts/tests/minimal.vim",
					}),
				}
			})

			require("neotest.logging"):set_level(vim.log.levels.DEBUG)

			vim.keymap.set("n", "<leader>tc", function()
				neotest.run.run()
			end)
		end,
		keys = {
			{ "<leader>ta", function() require("neotest").run.attach() end, desc = "[t]est [a]ttach" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "[t]est run [f]ile" },
			{ "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "[t]est [A]ll files" },
			{ "<leader>tS", function() require("neotest").run.run({ suite = true }) end, desc = "[t]est [S]uite" },
			{ "<leader>tn", function() require("neotest").run.run() end, desc = "[t]est [n]earest" },
			{ "<leader>tl", function() require("neotest").run.run_last() end, desc = "[t]est [l]ast" },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "[t]est [s]ummary" },
			{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "[t]est [o]utput" },
			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "[t]est [O]utput panel" },
			{ "<leader>tt", function() require("neotest").run.stop() end, desc = "[t]est [t]erminate" },
		},
	},
}

