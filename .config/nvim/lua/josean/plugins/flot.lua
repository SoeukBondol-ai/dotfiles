return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
      open_mapping = [[<leader>t]],
      insert_mappings = false,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
