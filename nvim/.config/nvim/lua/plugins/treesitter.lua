-- Treesitter (master branch): syntax highlighting + indentation.
-- The master branch compiles parsers with a plain C compiler (`cc`), so it needs
-- no external `tree-sitter` CLI — the `main` branch does, which isn't installed
-- here. This is the stable, documented API for the master branch.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "python",
        "go",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "prisma",
        "bash",
        "dockerfile",
        "yaml",
        "toml",
        "vim",
        "vimdoc",
        "gitcommit",
        "gitignore",
        "regex",
        "diff",
      },
      auto_install = true, -- install a missing parser when a new filetype opens
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
  },
}
