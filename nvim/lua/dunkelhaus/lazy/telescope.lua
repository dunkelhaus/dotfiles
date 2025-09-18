return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{ 'nvim-telescope/telescope-ui-select.nvim' },
	},

	config = function()
		require('telescope').setup({
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				}
			},
		})

		require('telescope').load_extension('ui-select')

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>pws', function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set('n', '<leader>pWs', function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

		vim.keymap.set('n', '<leader>fr', function()
			builtin.lsp_references({ noremap = true, silent = true });
		end)
		vim.keymap.set('n', '<leader>fif', function()
			builtin.current_buffer_fuzzy_find({ noremap = true, silent = true });
		end)
		vim.keymap.set('n', '<leader>ta', function()
			builtin.treesitter({ noremap = true, silent = true });
		end)
		vim.keymap.set('n', '<leader>tf', function()
			builtin.treesitter({ symbols = { "method", "function" } });
		end)
		vim.keymap.set('n', '<leader>lc', function()
			builtin.commands({ noremap = true, silent = true });
		end)
	end
}

