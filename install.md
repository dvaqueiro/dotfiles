Install dotfiles:
-----------------
```bash
sudo apt intall git
git clone git@github.com:dvaqueiro/dotfiles.git

```
Install zsh && oh-my-zsh && plugins :
-------------------------------------
```Bash
sudo apt-get install -y zsh curl wget
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo apt-get install -y fonts-powerline

# plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#(!!! Outdated)
mv ~/.zshrc ~/.zshrc_original
cp Documents/dev/dotfiles/config/.zshrc ./

```

Install node:
-------------
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

Various:
--------
snap-install universal-ctags
sudo apt-get install fonts-hack-ttf
sudo npm install -g tldr


Tmux Installation:
------------------
sudo apt-get install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Nvim installation:
------------------
snap install nvim --channel=latest/candidate
sudo apt-get install python3-pip
python3 -m pip install --user --upgrade pynvim
(Copy configuration -- OUTDATED)
