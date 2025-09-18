local prompts = {
	-- Code related prompts
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	FixCode = "Please fix the following code to make it work as intended.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	Documentation = "Please provide documentation for the following code.",
	SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
	SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
	-- Text related prompts
	GoifyDoc = "Please rewrite this comment to follow Go's single-line comment style.",
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

return {
	{ import = "dunkelhaus.lazy.copilot-vim" },
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>a", group = "ai" },
				{ "gm", group = "Copilot chat" },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
		ft = { "markdown", "copilot-chat" },
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		-- branch = "main",
		version = "v4.6.0", -- Use a specific version to prevent breaking changes
		dependencies = {
			{ "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",
			chat_autocomplete = false,
			prompts = prompts,
			show_help = true, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
			mappings = {
				-- Use tab for completion
				-- complete = {
				-- 	detail = "Use @<Tab> or /<Tab> for options.",
				-- 	insert = "<C-j>",
				-- },
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				-- Accept the diff
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				-- Show help
				show_help = {
					normal = "g?",
				},
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)

			-- Dynamic system prompt with project specific instructions from .github/copilot-instructions.md
			chat.config.system_prompt = function()
				local file_path = vim.fn.getcwd() .. '/.github/copilot-instructions.md'
				local base_system_prompt = [[
You are an AI programming assistant with deep project understanding.
You have access to the current buffer and any additional context provided.
Always consider the full project context, architecture, and patterns when answering.
Act as a senior developer who understands the entire codebase.
Provide actionable, contextual advice that fits the project's conventions, if any
project specific instructions are provided.
If you need more context about the project structure, ask for it specifically.
]]

				if vim.fn.filereadable(file_path) == 1 then

					local lines = vim.fn.readfile(file_path)
					local instructions = "\n\n=== PROJECT SPECIFIC INSTRUCTIONS ===\n" .. table.concat(lines, "\n") .. "\n"

					-- Print a message to the user that project specific instructions are being used
					vim.notify_once("Using project specific instructions from " .. file_path)
					return base_system_prompt .. instructions
				end

				return base_system_prompt
			end

			-- Use visual selection as context for CopilotChat
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { resources = 'selection' })
			end, { nargs = "*", range = true })

			-- Use open buffer as context for CopilotChat
			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { resources = 'buffer' })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		event = "VeryLazy",
		keys = {
			-- Show prompts actions with telescope
			{
				"<leader>ap",
				function()
					require("CopilotChat").select_prompt({
						context = {
							"buffers",
						},
					})
				end,
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>ap",
				function()
					require("CopilotChat").select_prompt()
				end,
				mode = "x",
				desc = "CopilotChat - Prompt actions",
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Chat with Copilot in visual mode
			{
				"<leader>av",
				function()
					local input = vim.fn.input("Chat with selection: ")
					if input ~= "" then
						vim.cmd("CopilotChatVisual " .. input)
					end
				end,
				mode = "x",
				desc = "CopilotChat - Ask with selection",
			},
			-- Custom input for CopilotChat
			{
				"<leader>ai",
				function()
					local input = vim.fn.input("Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Generate commit message based on the git diff
			{
				"<leader>am",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>ab",
				function()
					local input = vim.fn.input("Chat w/ buffer: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat with buffer",
			},
			-- Fix the issue with diagnostic
			{ "<leader>af", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
			-- Clear buffer and chat history
			{ "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
			-- Toggle Copilot Chat Vsplit
			{ "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
		},
	},
}
