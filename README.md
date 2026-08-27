# Terminal dotfiles

A [chezmoi](https://www.chezmoi.io/) source repository for reproducing this terminal setup on macOS or a headless Linux machine.

## What it configures

- **Zsh** with Starship, syntax highlighting, autosuggestions, and Neovim aliases.
- **Neovim** based on kickstart.nvim, including its plugins and lock file.
- **Kitty** with Catppuccin Mocha and 0xProto Nerd Font on macOS only.
- **Homebrew/Linuxbrew** packages required by the configuration.

Chezmoi translates names such as `dot_zshrc`, `dot_bashrc`, and `dot_config` into `~/.zshrc`, `~/.bashrc`, and `~/.config`. Do not copy source files into `$HOME` under their repository names.

## Requirements

- An internet connection for Homebrew, packages, and Neovim plugins.
- A regular, non-root user. Homebrew on Linux must not be installed as root.
- **macOS:** install Xcode Command Line Tools with `xcode-select --install`.
- **Debian/Ubuntu:** `curl`, `git`, and an account with `sudo`. On a minimal server, run `sudo apt-get update && sudo apt-get install -y curl git` first. The bootstrap installs `build-essential`, `gcc`, `g++`, and `make` with the remaining Linuxbrew prerequisites.
- **Other Linux distributions:** install Homebrew's compiler/toolchain prerequisites and Homebrew manually first. The dotfiles work there, but prerequisite installation is only automated for Debian and Ubuntu.

## Install

> [!WARNING]
> Applying dotfiles can overwrite existing files. Back up `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and, on macOS, `~/.config/kitty` first.

Replace `<repository-url>` with this repository's HTTPS or SSH URL:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <repository-url>
```

The run-once script installs Homebrew when needed and applies the `Brewfile`. On Linux it skips Kitty and its font because a headless server does not need GUI packages. Start Neovim once to install plugins:

```sh
nvim
```

Then run `:checkhealth kickstart` inside Neovim.

### Make Zsh the login shell on Linux

The setup installs Zsh, but deliberately does not change your login shell. Locate the Homebrew Zsh and register it once, then select it:

```sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
ZSH_PATH="$(brew --prefix)/bin/zsh"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
chsh -s "$ZSH_PATH"
```

Log out and reconnect. If an enterprise PAM policy (such as an SSH/JIT environment) prevents `chsh`, the managed `.bashrc` automatically initializes Linuxbrew and replaces an interactive Bash terminal with its Homebrew Zsh. Non-interactive Bash sessions are left unchanged.

### SSH and icons

A headless server does not install a font. Glyphs are rendered by the terminal on the computer from which you SSH, so install a Nerd Font **locally** and select it in that terminal. The configuration remains functional if icons display as boxes, but you can set `vim.g.have_nerd_font = false` in `dot_config/nvim/init.lua` to use plain symbols.

Clipboard integration depends on the SSH client and session. Neovim otherwise works normally; clipboard health warnings do not prevent editing.

### Install from an existing clone

With chezmoi already installed, run from the repository root:

```sh
chezmoi init --source "$PWD"
chezmoi diff
chezmoi apply
```

## Maintenance

Edit and review managed files through chezmoi:

```sh
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
```

Use `chezmoi update` to pull and apply repository updates, and `chezmoi add ~/.config/example/config` to manage a new file. Update dependencies in `Brewfile` and apply them with:

```sh
brew bundle --file "$(chezmoi source-path)/Brewfile"
```

## Scope and troubleshooting

- Language runtimes are not installed globally. Install only those needed by your projects; Neovim's Mason integration manages supported editor tooling separately.
- Socket Firewall (`sfw`) support in `.zshrc` is optional and activates only if `sfw` exists. Its credentials are not stored here.
- Git identity, SSH keys, API keys, and other machine-specific secrets must remain outside this repository.
- Windows is unsupported.
- If `brew` is unavailable in a new shell, the managed `.zshrc` checks the standard Apple Silicon, Intel macOS, and Linuxbrew prefixes.
- Preview changes safely at any time with `chezmoi diff`.
