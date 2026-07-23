return {
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      dashboard = { enabled = false },
    },
    keys = {
      -- Zen mode
      {
        "<leader>cz",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
    },
  },
}
