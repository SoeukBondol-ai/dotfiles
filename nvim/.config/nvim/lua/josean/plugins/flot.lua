return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
      open_mapping = [[<leader>t]],
      insert_mappings = false,
      start_in_insert = false,
      persist_size = true,
      persist_mode = true,
      float_opts = {
        border = "none",
        width = math.floor(vim.o.columns * 0.85),
        height = math.floor(vim.o.lines * 0.85),
      },
    },
  },
}
