#!/bin/bash

# Install Neovim 0.5 nightly Linux appimage with:
#   - Gnome Desktop integration
#   - Vimplug ready to add plugins
#   - Visual Studio Code theme with treesitter support
#   - bat and ripgrep binaries for enhanced functionality in fzf.vim plugin

hash nvim 2>/dev/null &&
    {
        echo 'You have nvim installed, it is not recommended to use this script.'
        exit 1
    }

INSTALL_DIR=/usr/local/bin
CONFIG_DIR=$HOME/.config/nvim

CODEDARK_URL=https://raw.githubusercontent.com/tomasiser/vim-code-dark/master/colors/codedark.vim

BAT_LOCATION=https://github.com/sharkdp/bat/releases/download/v0.18.1/
BAT_FILENAME=bat-v0.18.1-x86_64-unknown-linux-gnu.tar.gz
RIPGREP_LOCATION=https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/
RIPGREP_FILENAME=ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz

#==============================================================================
# Install Neovim nightly with gnome desktop integration
#==============================================================================
curl -LOf https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x ./nvim.appimage
sudo mv nvim.appimage $INSTALL_DIR/nvim
mkdir -p "$CONFIG_DIR"/plugged
xdg-desktop-menu install --novendor nvim.desktop
xdg-icon-resource install --novendor --mode user --size 64 nvim.png

#==============================================================================
# Install vimplug
#==============================================================================
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#==============================================================================
# Install codedark theme (with treesitter support)
#==============================================================================
curl --create-dirs $CODEDARK_URL -o "$CONFIG_DIR/colors/codedark.vim"

#==============================================================================
# If not installed, install binaries for enhanced fzf.vim functionality
#==============================================================================

# Install bat
hash bat 2>/dev/null ||
    {
        curl -LOf $BAT_LOCATION$BAT_FILENAME
        sudo tar -C $INSTALL_DIR/ -xf $BAT_FILENAME --no-anchored 'bat' --strip=1
        rm $BAT_FILENAME
    }

# Add alias to use Visual Studio Code theme in bat, at least v0.18.1 required
LINE='export BAT_THEME="Visual Studio Dark+"'
FILE="$HOME/.bashrc"
grep -qxF "$LINE" "$FILE" || echo "$LINE" >>"$FILE"

# Install ripgrep
hash rg 2>/dev/null ||
    {
        curl -LOf $RIPGREP_LOCATION$RIPGREP_FILENAME
        sudo tar -C $INSTALL_DIR/ -xf $RIPGREP_FILENAME --no-anchored 'rg' --strip=1
        rm $RIPGREP_FILENAME
    }

# Create basic init.vim to install fzf
if [ ! -e "$CONFIG_DIR/init.vim" ]; then
    cat >>"$CONFIG_DIR/init.vim" <<EOL
"======================================="
"            Load plugins               "
"======================================="

call plug#begin('$CONFIG_DIR/plugged')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
call plug#end()

"======================================="
"         Load colour scheme            "
"======================================="

colorscheme codedark

"======================================="
"             Map keys                  "
"======================================="

let mapleader = "\<Space>"

nnoremap <silent><c-p> :Files!<CR>
nnoremap <silent><leader>b :Buffers!<CR>
nnoremap <silent><leader>h :History!<CR>
nnoremap <silent><leader>gl :GFiles!<CR>
nnoremap <silent><leader>gs :GFiles?<CR>
nnoremap <silent><leader>gc :BCommits!<CR>
nnoremap <silent><leader>rg :Rg!<CR>
EOL
fi

cat <<EOL
================================================================================
All sorted, now edit your config at $CONFIG_DIR/init.vim !

Use :Pluginstall to tell vimplug to install the plugins in your init.vim

After the fzf plugin is installed you can symlink the binary for general use:

mkdir -p "$HOME"/bin
ln -s "$CONFIG_DIR"/plugged/fzf/bin/fzf "$HOME"/bin

To setup the LSP follow instructions at https://github.com/neovim/nvim-lspconfig
================================================================================
EOL

# cat >>"$HOME/.bashrc" <<EOL
# export BAT_THEME="Visual Studio Dark+"
# EOL
