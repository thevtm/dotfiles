# Vini's Dotfiles

## Usage

```sh
./install
```

## Fonts

* [ttf-dejavu](https://www.archlinux.org/packages/extra/any/ttf-dejavu/) base font
* [adobe-source-code-pro-fonts](https://www.archlinux.org/packages/extra/any/adobe-source-code-pro-fonts/) default Monospace font
* [terminus-font](https://www.archlinux.org/packages/community/any/terminus-font/) for PowerArrow (Awesome WM theme)
* [FiraCode](https://github.com/tonsky/FiraCode) VSCode font
* [ttf-font-awesome](https://aur.archlinux.org/packages/ttf-font-awesome/) glyphs

## Shell / Terminal

* [zinit](https://github.com/zdharma-continuum/zinit) plugin manager
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
* [Alacritty](https://github.com/alacritty/alacritty)

### Productivity

* [zoxide](https://github.com/ajeetdsouza/zoxide) smarter `cd` that jumps to frequent directories
* [fzf](https://github.com/junegunn/fzf) fuzzy finder
* [fd](https://github.com/sharkdp/fd) better and faster `find`
* [xsel](https://github.com/kfish/xsel) shell to clipboard
* [trash-cli](https://github.com/andreafrancia/trash-cli) trash functionality for cli
* [direnv](https://github.com/direnv/direnv) enviroment switcher for shell
* [jq](https://stedolan.github.io/jq/) jq is like sed for JSON data
* [eza](https://github.com/eza-community/eza) better `ls`
* [tldr](https://tldr.sh) better `man`
* [httpie](https://httpie.org/) better cURL
* [ripgrep](https://github.com/BurntSushi/ripgrep) ripgrep

## Network

* [networkmanager](https://wiki.archlinux.org/index.php/NetworkManager) handle all things related to networks for both wired and wireless
* [network-manager-applet](https://wiki.archlinux.org/index.php/NetworkManager#nm-applet) useful tool to configure Network Manager

## Audio

[ALSA](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture): [alsa-utils](https://www.archlinux.org/packages/extra/i686/alsa-utils/)

## Other

- [asdf-vm](https://asdf-vm.com/) generic version manager for developers

## Config

### Quake Terminal

[Gnome Extension](https://extensions.gnome.org/extension/6307/quake-terminal/)

### Git

```ini
[user]
    name = Bob
    email = bob@example.com
    signingkey = 123456789

[commit]
    gpgsign = true

[includeIf "gitdir:/home/bob/Documents/github/"]
    path = /home/bob/Documents/github/.gitconfig
```

## CLI Cheat Sheet

```sh
# System update (alias defined in ./aliases)
system-update
```
