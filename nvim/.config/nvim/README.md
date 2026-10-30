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
├── tests/agent_workflow.lua # isolated agent terminal / refresh checks
└── lua/
    ├── config/
    │   ├── options.lua      # vim options (leader, UI, rounded borders…)
    │   ├── keymaps.lua      # core, plugin-independent keymaps
    │   ├── autocmds.lua     # autocommands
    │   ├── agent.lua        # project agent terminals and context shortcuts
    │   ├── file_refresh.lua # safe refresh after external edits
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
- **AI agents:** reusable native terminal splits for Codex, Claude, or other CLIs,
  grouped under `Space a` in Which-Key; sessions stay alive when hidden.
- **External edits:** refresh unmodified buffers every 1.5 seconds and when
  returning from terminals; buffers with unsaved work are skipped.

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

## Coding with AI agents

New additions: `config/agent.lua` manages the project terminals and context-copy
shortcuts; `config/file_refresh.lua` handles external edits. They load from the
existing init/autocommand setup. Terminal navigation lives in `config/keymaps.lua`,
and the new AI / Agent shortcut group is registered in Which-Key.

Restart Neovim after updating this configuration. Your Stow link already points
here; on another machine, run `stow --target="$HOME" nvim` from the dotfiles repo.
This workflow uses Neovim's native terminal and needs no extra plugin.

Leader is Space. Start Neovim inside your project (`cd my-project && nvim .`),
save your work with `Space w`, then use:

| Keys | Action |
| ---- | ------ |
| `Space a c` | Open/focus Codex |
| `Space a l` | Open/focus Claude |
| `Space a a` | Open/focus the last agent; hide it when already focused |
| `Ctrl-g` in an agent | Hide its split; the session keeps running |
| `Ctrl-h/j/k/l` in a terminal | Leave terminal input and move to an adjacent split |
| `Space a t` | Open/focus a project shell |
| `Space a y` | Copy the current file and line to the clipboard |
| Select lines, then `Space a y` | Copy the file and selected line range |
| `Space a r` | Refresh files changed outside Neovim |

1. Press `Space a c` or `Space a l`, type your prompt, and press Enter.
2. Press `Ctrl-h` to move from a right-hand agent split to your code, or `Ctrl-g`
   to hide the agent. On narrow windows the terminal opens below the code;
   use `Ctrl-k` to move up. Reopen it with `Space a a`; `i` resumes input when
   already viewing a terminal in Normal mode.
3. Files without unsaved edits refresh about every 1.5 seconds, including while
   the agent runs. Focus/buffer changes and leaving terminal input also trigger
   checks. Refresh waits while you are in Insert, Replace, Visual, or command mode.
4. Review edits with `Space g g` (Git status), `[h` / `]h` (previous/next hunk),
   `Space g p` (preview hunk), or `Space g d` (diff the current file). Use
   `:diffoff` to leave the current file's diff view. Git shows all working-tree
   changes, including edits made before the agent started.
5. To give the agent context, copy a reference with `Space a y`, switch to the
   agent, and paste using your terminal's clipboard paste shortcut. This copies
   a reference such as `src/main.ts:12-24`; it does not submit a prompt.

Sessions are separate for each Git root and command, and survive hiding the split
until Neovim exits. Outside Git, the working directory is used. Closing and
reopening an exited agent starts a new process; conversation recovery is handled
by the CLI itself. Escape and Ctrl-C keep their agent meanings. In a manually
opened `:terminal`, `Ctrl-g` just leaves terminal input mode.

Use `:Agent opencode` (or another installed CLI) for other agents. Arguments are
supported, for example `:Agent codex resume`. `:Agent` toggles the last command
for the project. These commands run directly, without shell expansion.

Automatic refresh skips buffers with unsaved edits. Save before asking an agent
to edit the same file. If both versions have changed, use `:checktime` to let
Neovim offer its conflict choices. The refresh behavior follows Neovim's
[`autoread` / `checktime` rules](https://neovim.io/doc/user/editing/#timestamp).
Codex runs as its normal interactive CLI, as described in the
[official OpenAI documentation](https://learn.chatgpt.com/docs/codex/cli).

Run the isolated workflow checks from the dotfiles repo:

```sh
XDG_STATE_HOME=/tmp/nvim-agent-tests nvim --headless -u NONE -i NONE -l nvim/.config/nvim/tests/agent_workflow.lua
```

### Using Neovim inside Herdr, tmux, or Ghostty

The outer applications receive keys before Neovim. This repository gives each
layer its own controls:

| Layer | Controls |
| ----- | -------- |
| Hyprland | `Super` shortcuts for desktop windows/workspaces |
| Ghostty | `Ctrl-Space`, release, then a Ghostty action key |
| Herdr | `F12`, release, then a Herdr action key |
| tmux | `Ctrl-a`, release, then a tmux action key |
| Neovim | `Space` leader shortcuts; `Ctrl-h/j/k/l` for split navigation |

Herdr previously used `Ctrl-a`, which also belongs to tmux and is Neovim's
increment-number key (and the shell's move-to-start-of-line key). Its prefix is
now `F12`, so `Ctrl-a` reaches the next layer. Herdr's pane navigation is
`F12 h/j/k/l`; bare `Ctrl-h/j/k/l` reaches Neovim. These keys only navigate
Neovim splits and, with the existing plugin, tmux panes; they do not navigate
Herdr panes.

Ghostty now forwards `Ctrl-Left/Right` to Neovim for split resizing. For shell
word movement, use `Alt-b` / `Alt-f` with the configured zsh Emacs bindings.
To page backward in Neovim while inside Herdr, `Ctrl-b` is available. Inside
tmux, its `Ctrl-a` prefix still takes precedence; these changes do not make
tmux forward a single `Ctrl-a` to Neovim.

See the root [README](../../../README.md#keyboard-layout) for the shared shortcut
table, reload instructions, and corrected Hyprland shortcuts.

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
