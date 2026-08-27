# Terminal dotfiles

A [chezmoi](https://www.chezmoi.io/) source repository for reproducing this macOS terminal setup.

## What it configures

- **Zsh** with Starship, syntax highlighting, autosuggestions, and Neovim aliases.
- **Kitty** with the Catppuccin Mocha theme and 0xProto Nerd Font.
- **Neovim** based on kickstart.nvim, including its plugins and lock file.
- **Homebrew** packages required by those configurations.

Chezmoi translates names such as `dot_zshrc` and `dot_config` into `~/.zshrc` and `~/.config` when it applies the repository. Do not copy the source files to `$HOME` under their repository names.

## Requirements

The automated bootstrap currently supports **macOS only**. Before starting, install:

1. Xcode Command Line Tools (provides the compiler and build tools used by Neovim plugins):
   ```sh
   xcode-select --install
   ```
2. Git, if it is not already available after installing the command-line tools.
3. An internet connection. The first apply installs Homebrew packages, and the first Neovim launch downloads plugins and developer tools.

No existing Homebrew or chezmoi installation is required when using the bootstrap command below.

## Install on a new Mac

> [!WARNING]
> Applying dotfiles can overwrite files already present in your home directory. Back up any existing `~/.zshrc`, `~/.config/kitty`, and `~/.config/nvim` first.

Use chezmoi's installer, replacing `<repository-url>` with this repository's HTTPS or SSH clone URL:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <repository-url>
```

During the first apply, the run-once script installs Homebrew when necessary and then runs the repository's `Brewfile`. Open a new Kitty window afterward, then start Neovim once so it can install its plugins:

```sh
nvim
```

Inside Neovim, verify external dependencies with:

```vim
:checkhealth kickstart
```

### Install from an existing clone

If you have already cloned the repository and have chezmoi installed:

```sh
chezmoi init --source "$PWD"
chezmoi diff
chezmoi apply
```

Run those commands from the repository root. `chezmoi diff` lets you review changes before they are written to your home directory.

## Day-to-day maintenance

Edit through chezmoi so changes are made in its source state:

```sh
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
```

To pull this repository's latest changes and apply them:

```sh
chezmoi update
```

To add a newly created dotfile to the managed source:

```sh
chezmoi add ~/.config/example/config
```

Homebrew dependencies belong in `Brewfile`; run `brew bundle --file Brewfile` from the source directory after changing it.

## Notes and optional software

- The prompt and Kitty configuration expect **0xProto Nerd Font**, installed by the `Brewfile`.
- The Socket Firewall (`sfw`) integration in `.zshrc` is optional and only activates when `sfw` is installed. Its own configuration and credentials are intentionally not stored here.
- Language runtimes (Node.js, Python, Go, Rust, and so on) are not installed globally by this repository. Install only the runtimes needed for your projects; Neovim's Mason integration handles supported editor tooling separately.
- Machine-specific secrets, API keys, SSH keys, and Git identity should remain outside this repository.
- Linux and Windows are not bootstrapped by the install script. The configuration may be adapted for them, but package installation and platform-specific Kitty/Zsh behavior require manual changes.

## Troubleshooting

- If `brew` is unavailable after installation, open a new shell. The managed `.zshrc` initializes Homebrew from the standard Apple Silicon or Intel prefix.
- If icons render as boxes, select **0xProto Nerd Font Mono** in Kitty and confirm the font cask installed successfully.
- If Neovim reports missing tools, run `:checkhealth kickstart` and `brew bundle --file "$(chezmoi source-path)/Brewfile"`.
- Preview what chezmoi would change at any time with `chezmoi diff`.
