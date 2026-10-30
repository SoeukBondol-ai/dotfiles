# My Dotfiles

My personal **dotfiles** setup managed with **[GNU Stow](https://www.gnu.org/software/stow/)** for clean, modular symlinking.

---

## Requirements

[GNU Stow](https://www.gnu.org/software/stow/)

First, install **GNU Stow**.  
It depends on your package manager. Since I use Arch Linux:

```bash
sudo pacman -S stow

```

## Installation

```bash

git clone https://github.com/SoeukBondol-ai/dotfiles.git ~/dotfiles

cd ~/dotfiles

stow .

```

That's it — all configs will be symlinked to their correct locations under `~`.

---

## Structure

Each app has its own folder that mirrors the path from `~`:

```

dotfiles/

├── nvim/

│   └── .config/nvim/       → ~/.config/nvim/

├── hypr/

│   └── .config/hypr/       → ~/.config/hypr/

└── ...

```

## New Neovim agent workflow

The Neovim package now includes reusable Codex/Claude terminal splits, automatic
refresh for external file changes, and a shortcut to copy file/line references
into prompts. No additional plugin is required. Restart Neovim after updating.

| Shortcut | Action |
| -------- | ------ |
| `Space a c` / `Space a l` | Open Codex / Claude in the current project |
| `Space a a` | Open/focus the last agent, or hide it when focused |
| `Ctrl-g` | Open/focus the last agent from code; hide it from the agent |
| `Ctrl-h/j/k/l` in a terminal | Move to an adjacent Neovim split |
| `Space a y` | Copy current file/line or selected line range for a prompt |
| `Space a r` | Refresh externally changed, unmodified files |
| `Space g g` | Review working-tree changes with Git status |

Unmodified buffers refresh every 0.5 seconds while the agent runs; unsaved
buffers are preserved. Save before asking an agent to change the same file.
Other CLI agents can be opened with `:Agent <command>`.

See the [Neovim README](nvim/.config/nvim/README.md#coding-with-ai-agents) for the
full workflow, conflict handling, and verification command.

## Keyboard layout

Press a prefix, release it, then press the action key. Separate prefixes prevent
Herdr, tmux, and Ghostty from competing for the same key sequence.

| Application | Prefix / shortcuts |
| ----------- | ------------------ |
| Ghostty | `Ctrl-Space` prefix |
| Herdr | `Ctrl-b` prefix (Herdr default) |
| tmux | `Ctrl-a` prefix |
| Neovim | `Space` leader; `Ctrl-h/j/k/l` for split navigation |
| Hyprland | `Super` for desktop actions |

Herdr examples: `Ctrl-b c` creates a tab, `Ctrl-b v` splits right, `Ctrl-b -` splits
down, `Ctrl-b h/j/k/l` changes panes, `Ctrl-b z` zooms, `Ctrl-b w` opens workspaces,
`Ctrl-b ?` shows active bindings, and `Ctrl-b q` detaches. `Ctrl-b Shift-r` reloads
Herdr's configuration. See the [Herdr keyboard documentation](https://herdr.dev/tui/docs/keyboard/)
for the prefix/action model.

Herdr's old `Ctrl-a` prefix conflicted with tmux, Neovim's increment-number
command, and shell line editing. The default `Ctrl-b` prefix leaves those keys to
the inner application. When using tmux, `Ctrl-a` is still tmux's prefix.
Herdr consumes `Ctrl-b`, so use `Ctrl-u` / `Ctrl-d` for Neovim half-page scrolling.

Ghostty no longer translates `Ctrl-Left/Right` into shell word movements, so
Neovim can receive its split-resize shortcuts. In zsh, use `Alt-b` / `Alt-f`
to move backward/forward by a word.

Hyprland had two actions each assigned to `Super-J` and `Super-K`. Window swaps
stay on `Super-H/J/K/L`; toggle split is now `Super-Ctrl-J`, and toggle the
special workspace is now `Super-Ctrl-K`. Moving a window to the special
workspace remains `Super-Shift-K`.

To apply:

- Restart Neovim.
- In a running Herdr client, use its global menu's **reload config** action to
  reload client and server settings, or restart Herdr. For the server alone,
  run `herdr server reload-config`.
- Reload Ghostty with `Ctrl-Space [` (your configured shortcut).
- Run `hyprctl reload` in your Hyprland desktop session.

Validate Herdr's configuration with `herdr config check`. Existing Stow links
point to these files; on a fresh machine, run `stow --target="$HOME" nvim herdr
ghostty hypr tmux` from this repo.

---

## Ignored Files

A `.stow-local-ignore` file is included to prevent Stow from symlinking

meta files when running `stow .`:

```

README.md

LICENSE

\.git

\.DS_Store

setup\.sh

```

---

## Existing Configs

If you already have configs at `~/.config/<app>`, Stow will refuse to overwrite them.

Back them up first:

```bash

mv ~/.config/nvim ~/.config/nvim.bak

```

Then re-run `stow .`
