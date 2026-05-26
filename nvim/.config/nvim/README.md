# Neovim Config

Neovim nightly (0.13+) config using built-in `vim.pack` package manager, mini.nvim, and native LSP.

## Structure

```
.
├── init.lua              -- Entry point, loads all modules
└── lua/
    ├── options.lua        -- Editor settings
    ├── keymaps.lua        -- General keymaps
    ├── commands.lua       -- :PackAdd, :PackDel, :PackUpdate commands
    ├── pack.lua           -- Plugins and plugin-specific keymaps
    ├── treesitter.lua     -- Treesitter parsers
    └── lsp.lua            -- LSP servers and Mason auto-install
```

## Requirements

- Neovim 0.13+ (nightly)
- `tree-sitter` CLI (`pacman -S tree-sitter`)
- `fd` (`pacman -S fd`) — for venv-selector
- `make` & C compiler — for telescope-fzf-native
- A Nerd Font (for icons)

## LSP Servers (auto-installed by Mason)

| Server        | Language               | Purpose                          |
|---------------|------------------------|----------------------------------|
| lua_ls        | Lua                    | Type checking, completion        |
| marksman      | Markdown               | Completion, references           |
| gopls         | Go                     | Full language support            |
| rust_analyzer | Rust                   | Full language support            |
| pyright       | Python                 | Type checking, navigation        |
| ruff          | Python                 | Linting, formatting, code actions|
| ts_ls         | TypeScript / JS / JSX  | Full language support            |
| html          | HTML                   | Completion, diagnostics          |
| cssls         | CSS                    | Completion, diagnostics           |

## Treesitter Parsers

go, rust, typescript, javascript, tsx, html, css, json, bash, http, dockerfile, python

---

## Keybindings

### Leader: `Space`

### General (keymaps.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `<leader>d`      | n, x   | Delete without yanking (black hole)       |
| `<leader>s`      | n      | Substitute word under cursor globally     |
| `<leader>X`      | n      | Make current file executable              |
| `<leader>re`     | n      | Restart Neovim config                     |
| `<leader>u`     | n      | Toggle built-in undotree                  |
| `p`              | x      | Paste over selection without losing yank  |
| `<C-c>`          | i      | Exit insert mode                          |
| `<C-c>`          | n      | Clear search highlighting                 |
| `J`              | n      | Join lines, keep cursor position          |
| `J` / `K`        | v      | Move selected lines down / up             |
| `<` / `>`        | v      | Unindent / indent (keep selection)        |
| `<C-d>` / `<C-u>`| n      | Scroll down / up (centered)              |
| `n` / `N`        | n      | Next / previous search result (centered) |

### LSP (lsp.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `gd`             | n      | Go to definition                          |
| `<leader>f`      | n      | Format buffer                              |
| `df`             | n      | Show line diagnostics float               |

### File Explorer — mini.files (pack.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `-`              | n      | Open file explorer                        |
| `<leader>-`      | n      | Open explorer at current file              |
| `<leader>ee`     | n      | Open file explorer                         |

### Pick / Finder — mini.picker (pack.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `<leader>pf`     | n      | Find files                                |
| `<leader>ps`     | n      | Grep word under cursor                    |
| `<leader>vh`     | n      | Search help                                |
| `<leader>xx`     | n      | Diagnostics picker                        |
| `<leader>pk`     | n      | Search keymaps                             |

### Telescope (pack.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `<leader>tf`     | n      | Find files                                |
| `<leader>tg`     | n      | Live grep                                 |
| `<leader>tb`     | n      | Buffers                                    |
| `<leader>th`     | n      | Help tags                                  |
| `<leader>to`     | n      | Recent files                               |
| `<leader>td`     | n      | Diagnostics                                |

### Git (pack.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `<leader>gg`     | n      | Fugitive full page (new tab)              |
| `<leader>gd`     | n      | Git diff split                             |

### Python — venv-selector (pack.lua)

| Key              | Mode   | Action                                    |
|------------------|--------|-------------------------------------------|
| `<leader>vs`     | n      | Select Python virtual environment         |

Auto-detects `.venv` and `venv` directories (works with `uv`).

### Surround — mini.surround (pack.lua)

| Key   | Action                                   |
|-------|------------------------------------------|
| `sa`  | Add surrounding (e.g. `saiw"`)           |
| `sd`  | Delete surrounding                       |
| `sr`  | Replace surrounding                      |
| `sf`  | Find surrounding (right)                 |
| `sF`  | Find surrounding (left)                  |
| `sh`  | Highlight surrounding                    |

---

## Plugins

| Plugin                     | Purpose                          |
|----------------------------|----------------------------------|
| vim-moonfly-colors         | Color scheme                     |
| mini.nvim                  | files, picker, surround, clue, completions, snippets, notify, cmdline, diff |
| nvim-treesitter            | Syntax highlighting              |
| nvim-lspconfig             | LSP configurations               |
| mason.nvim                 | LSP server installer              |
| mason-tool-installer       | Auto-install LSP servers          |
| vim-fugitive               | Git integration                   |
| telescope.nvim             | Fuzzy finder                      |
| telescope-fzf-native       | FZF sorter for telescope          |
| venv-selector.nvim         | Python venv auto-detection        |
| friendly-snippets          | Snippet collection                |

## Commands

| Command            | Action                                  |
|--------------------|-----------------------------------------|
| `:PackAdd <repo>`  | Add plugin(s) by repo URL              |
| `:PackDel <name>`  | Delete plugin(s)                        |
| `:PackUpdate [name]`| Update all or specific plugins         |

## Editor Options (options.lua)

- Relative line numbers
- 4-space tabs, expanded to spaces
- No line wrapping
- Smart indent
- Live substitute preview (`inccommand=split`)
- Splits open below/right
- Smart case-insensitive search
- Global statusline
- No swap/backup files, persistent undo
- System clipboard (unnamedplus)
- 8-line scroll offset
- Sign column always on
- Yank highlight on copy