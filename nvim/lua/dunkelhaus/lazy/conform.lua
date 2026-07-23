return {
	"stevearc/conform.nvim",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(
					opts.ensure_installed,
					{ "gofumpt", "goimports", "gci", "golines", "ruff_fix", "ruff_format", "ruff_organize_imports", "prettier" }
				)
			end,
		},
	},

	config = function()
			require("conform").setup({
				formatters_by_ft = {
					go = { "golines", lsp_format = "fallback" },
					json = { "prettier", lsp_format = "fallback" },
					jsonc = { "prettier", lsp_format = "fallback" },
					python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				},
				formatters = {
					gofumpt = {
						prepend_args = { "-extra" },
				},
				gci = {
					args = { "write", "--skip-generated", "-s", "standard", "-s", "default", "--skip-vendor", "$FILENAME" },
				},
				goimports = {
					args = { "-srcdir", "$FILENAME" },
				},
				golines = {
					timeout_ms = 5000,
					-- golines will use goimports as base formatter by default which is slow.
					-- see https://github.com/segmentio/golines/issues/33
					prepend_args = { "--base-formatter=gofumpt", "--ignore-generated", "--tab-len=1", "--max-len=100" },
				},
			},
		})
		vim.keymap.set("n", "<leader>f", require("conform").format)
	end,
}
