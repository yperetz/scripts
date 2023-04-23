#!/bin/bash -x

sudo apt update
sudo apt upgrade -y

for i in python3 python python3-pip exa zsh snapd gdebi-core wget htop python3-neovim git pynvim ruby-full fzf neofetch terminator plank conky-all bat curl pulse-audio-equalizer vlc; do
    sudo apt install -y $i
done

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

sudo snap install pycharm-professional --classic

sudo gem install neovim

# nodejs
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g neovim

# exa
 curl -fsSLo /tmp/exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
 cd /tmp
 unzip /tmp/exa.zip
 sudo mv /tmp/bin/exa /usr/local/bin/
 sudo mv /tmp/man/exa.1 /usr/share/man/man1/
 sudo mv /tmp/completions/exa.zsh /usr/local/share/zsh/site-functions/
 cd ~


# install brave
sudo apt install apt-transport-https curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# install oh-my-zsh
ZSH=
echo $ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting # syntax highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions # autosuggestions

 #install discord and zoom
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
wget -O /tmp/zoom_amd64.deb "https://zoom.us/client/latest/zoom_amd64.deb"
sudo gdebi /tmp/discord.deb --n
sudo gdebi /tmp/zoom_amd64.deb --n

# ulauncher
mkdir ~/.config/autostart
wget -O /tmp/ul.deb "https://github.com/Ulauncher/Ulauncher/releases/download/5.13.0/ulauncher_5.13.0_all.deb"
sudo gdebi /tmp/ul.deb --n
cp /usr/share/applications/ulauncher.desktop ~/.config/autostart/
# same for plank
cp /usr/share/applications/plank.desktop ~/.config/autostart/

# install neovim vim plug
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install fonts
font_dir="$HOME/.local/share/fonts"
mkdir -p $font_dir
if [ ! -f ~/.fonts/DejaVu\ Sans\ Mono\ for\ Powerline.ttf ]; then
    echo "Installing Shell fonts..."
    sudo curl -fsSLo /tmp/JetBrainsMono.ttf https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf?raw=true
    cp /tmp/JetBrainsMono.ttf $font_dir/
fi

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi

###########################################################################
# CONFIGURATION
###########################################################################

# make python3 default
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# make zsh default
sudo chsh -s $(which zsh) $USER
cd ~

# oh my zsh
rm ~/.zshrc


# get dotfiles
git clone https://github.com/prophet-five/dotfiles.git

# link dotfiles
cd dotfiles
for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md|\.config$' ) ; do
    # Silently ignore errors here because the files may already exist
    ln -sv "$PWD/$file" "$HOME" || true
  done
sudo ln -sv "$PWD/logid.cfg" "/etc/" || true
cd ~

rm -rf ~/.config/xfce4
rm -rf ~/.config/plank

cd dotfiles/.config
for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md|\.config$' ) ; do
    # Silently ignore errors here because the files may already exist
    ln -sv "$PWD/$file" "$HOME/.config" || true

