# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io).

Managed today:

- neovim, `~/.config/nvim` (lazy.nvim, Copilot Chat, LSP for python and go)
- wezterm, `~/.config/wezterm`
- opencode, `~/.config/opencode`. `service.json` is not managed.

Note: `.chezmoiignore` keeps `README.md` out of the home directory.

## New machine setup

Install chezmoi, clone this repo, and apply the dotfiles in one step:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --ssh dunkelhaus
```

This installs chezmoi, clones the repo to `~/.local/share/chezmoi`, and writes the
config files into the home directory. Neovim installs its plugins on first use.

This machine keeps the source repo at `~/code/dotfiles` instead. To copy that setup:

```sh
git clone git@github.com:dunkelhaus/dotfiles.git ~/code/dotfiles
mkdir -p ~/.config/chezmoi
printf 'sourceDir = "~/code/dotfiles"\n' > ~/.config/chezmoi/chezmoi.toml
chezmoi apply
```

## Daily use

| Command | Purpose |
| --- | --- |
| `chezmoi cd` | Open the source repo. Commit and push your changes there. |
| `chezmoi edit ~/.config/opencode/opencode.json` | Edit the source copy of one file. |
| `chezmoi diff` | Preview what `apply` would change. |
| `chezmoi apply` | Write source changes into the home directory. |
| `chezmoi update` | Pull the latest repo state and apply it. |
| `chezmoi managed` | List every managed file. |
| `chezmoi add <file-or-dir>` | Put a new file or directory under management. |
