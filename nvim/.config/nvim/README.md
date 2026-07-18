# Neovim configuration

A clean, modular Neovim config managed with **[lazy.nvim](https://github.com/folke/lazy.nvim)**
(the only plugin manager used here). Built for Neovim **0.11+** (tested on 0.12).

Deployed with GNU Stow — this lives in the `nvim` stow package and symlinks to
`~/.config/nvim`.

## Structure

```
.config/nvim/
├── init.lua                # entry point
├── lazy-lock.json          # pinned plugin versions (commit this)
└── lua/
    ├── config/
    │   ├── options.lua      # vim options (leader, UI, rounded borders…)
    │   ├── keymaps.lua      # core, plugin-independent keymaps
    │   ├── autocmds.lua     # autocommands
    │   └── lazy.lua         # lazy.nvim bootstrap + setup
    └── plugins/
        ├── ui.lua           # tokyonight, lualine, bufferline, noice, which-key
        ├── navigation.lua   # telescope, neo-tree, tmux-navigator
        ├── lsp.lua          # mason, mason-lspconfig, LSP servers + keymaps
        ├── completion.lua   # blink.cmp
        ├── formatting.lua   # conform.nvim + nvim-lint
        ├── treesitter.lua   # nvim-treesitter (highlighting/indent)
        ├── git.lua          # gitsigns, fugitive, lazygit
        └── editor.lua       # autopairs, surround, ts-autotag, sessions, trouble
```

## Highlights

- **Theme:** Tokyo Night (`night`), rounded borders on *all* floats via
  `vim.o.winborder`.
- **UI:** Noice command-line popup + notifications, Which-Key, Lualine, Bufferline.
- **Finder:** Telescope (with fzf-native). Explorer: Neo-tree.
- **LSP:** native `vim.lsp.config`/`vim.lsp.enable` (Neovim 0.11+ API), servers
  installed by Mason. Completion via **blink.cmp**.
- **Formatting:** conform.nvim (format-on-save). **Linting:** nvim-lint.
- **Navigation:** seamless Neovim ⇄ tmux pane movement with `<C-h/j/k/l>`.

### Language support (LSP)

`basedpyright` + `ruff` (Python), `ts_ls` (TS/JS/React), `eslint`, `html`,
`cssls`, `tailwindcss`, `jsonls`, `lua_ls`, `emmet_language_server`, `prismals`.

> `eslint` and `tailwindcss` only attach when the project has the relevant config
> file (e.g. `.eslintrc*`, `tailwind.config.*`) — this is expected behaviour.

### Formatters

`ruff` (Python), `prettier` (JS/TS/HTML/CSS/JSON/Markdown/YAML), `stylua` (Lua),
and the Prisma LSP formats `.prisma` files (via conform's LSP fallback).

## Key mappings

Leader is `<Space>`. Which-Key shows everything live; the essentials:

| Keys          | Action                           |
| ------------- | -------------------------------- |
| `<leader>ff`  | Find files                       |
| `<leader>fg`  | Live grep (search text)          |
| `<leader>fr`  | Recent files                     |
| `<leader>fb`  | Buffers                          |
| `<leader>ee`  | Toggle file explorer (Neo-tree)  |
| `<leader>cf`  | Format buffer                    |
| `<leader>cr`  | Rename symbol (LSP)              |
| `<leader>ca`  | Code action (LSP)                |
| `<leader>cd`  | Line diagnostics                 |
| `gd` / `gr`   | Definition / references (LSP)    |
| `K`           | Hover documentation              |
| `[d` / `]d`   | Prev / next diagnostic           |
| `<leader>xx`  | Diagnostics list (Trouble)       |
| `<leader>gg`  | Git status (fugitive)            |
| `<leader>gl`  | LazyGit                          |
| `<leader>gs`  | Stage hunk                       |
| `<leader>w`   | Save file                        |
| `<leader>q`   | Close window                     |
| `<C-h/j/k/l>` | Move between splits / tmux panes |
| `<leader>Ss`  | Restore session (cwd)            |
| `<leader>l`   | Open Lazy plugin manager         |

## Requirements

- Neovim **0.11+** (0.12 recommended)
- `git`, a C compiler (`cc`/`gcc`) for Treesitter parsers
- `node`/`npm` (for the JS/TS/web language servers & prettier)
- Optional: `lazygit` binary for `<leader>gl`, `ripgrep` for faster Telescope grep

## Notes

- Plugins install automatically on first launch. Run `:Lazy` to manage them,
  `:Mason` to manage LSP servers/formatters, `:checkhealth` to diagnose issues.
- Treesitter uses the **master** branch (compiles parsers with `cc`; no external
  `tree-sitter` CLI needed).
