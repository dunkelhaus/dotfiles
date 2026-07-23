return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities())

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		local servers = {
			---@type vim.lsp.Config
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = {
							globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
						}
					}
				}
			},

			---@type vim.lsp.Config
			gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
				root_markers = { "go.work", "go.mod", ".git" },
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = false,
					},
				},
			},

			---@type vim.lsp.Config
			ruff = {
				cmd = { "ruff", "server" },
				filetypes = { "python" },
				root_dir = (function()
					return vim.fs.root(0, {
						"pyproject.toml",
						"ruff.toml",
						".ruff.toml",
						"requirements.txt",
						"uv.lock",
						"setup.py",
						"setup.cfg",
						"Pipfile",
						"pyrightconfig.json",
						".git",
					})
				end)(),
				on_attach = function(client, bufnr)
					if client.name == "ruff" then
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end
				end,
				init_options = {
					settings = {
						configurationPreference = "filesystemFirst",
						lineLength = 88,
					},
				},
				settings = {
					ruff = {},
				},
			},

			---@type vim.lsp.Config
			basedpyright = {
				cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = {
					"pyproject.toml",
					"ruff.toml",
					".ruff.toml",
					"requirements.txt",
					"uv.lock",
					"setup.py",
					"setup.cfg",
					"Pipfile",
					"pyrightconfig.json",
					".git",
				},
				settings = {
					python = {
						venvPath = vim.fn.getenv("VIRTUAL_ENV"),
						pythonPath = vim.fn.exepath("python"),
					},
					basedpyright = {
						disableOrganizeImports = true, -- use ruff lsp for this instead
						analysis = {
							-- ignore = { "*" }, -- NOTE: uncomment this to ignore linting.
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			},

			---@type vim.lsp.Config
			copilot = {},
		}

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup {
			automatic_enable = true,
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"jsonls",
		})
		require("mason-tool-installer").setup {
			ensure_installed = ensure_installed,
		}

		-- Installed LSPs are configured and enabled automatically with mason-lspconfig
		-- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
		for server_name, config in pairs(servers) do
			vim.lsp.config(server_name, config)
		end

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' }, -- For luasnip users.
			}, {
				{ name = 'buffer' },
			})
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end
}
