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
