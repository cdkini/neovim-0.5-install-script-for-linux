# neovim-0.5-install-script-for-linux

![Neovim logo](https://github.com/David-Else/neovim-0.5-install-script-for-linux/blob/main/nvim.png)

A minimal install script to get the beginner with the sense to be using Linux up and running with the latest Neovim out of the box!

## Features:

- Installs the latest appimage nightly version of Neovim
- Adds Gnome Desktop integration with an icon
- Downloads Vimplug ready to add plugins
- Installs classic dark Visual Studio Code theme with treesitter support
- Installs the latest [bat](https://github.com/sharkdp/bat) and [ripgrep](https://github.com/BurntSushi/ripgrep) binaries for enhanced functionality in the [fzf.vim](https://github.com/junegunn/fzf/blob/master/README-VIM.md) plugin (if you don't have any versions installed)
- Very minimal `init.vim` that simply installs `fzf`, adds some key maps for it, and loads the theme

Now you are ready to enter the wonderful world of Neovim without having to waste any time figuring out how to get all the files and directories configured when using the appimage.

For a comprehensive list of plugins check out https://github.com/rockerBOO/awesome-neovim

I recommend:

```
  " use built-in LSP and treesitter features
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'neovim/nvim-lspconfig'
  " auto completion and LSP codeAction alert
  Plug 'hrsh7th/nvim-compe'
  Plug 'kosayoda/nvim-lightbulb'
  " preview markdown in web browser using pandoc
  Plug 'davidgranstrom/nvim-markdown-preview'
  " zen mode
  Plug 'folke/zen-mode.nvim'
  " toggle the terminal
  Plug 'akinsho/nvim-toggleterm.lua'
```
