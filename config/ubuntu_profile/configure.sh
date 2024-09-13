#!/bin/bash
#sudo chmod +x /usr/local/bin/update.sh
set -e
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt install wget
sudo apt install curl
sudo apt install git
sudo apt install zsh
chsh -s /bin/zsh
#chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
cd $ZSH_CUSTOM/plugins/
sudo chmod 755 ./zsh*
cd ~
