#!/bin/bash
set -ex

SELF="$(dirname "$(readlink -e "$0")")"
cd "$SELF"

curl https://linux.mellanox.com/public/repo/doca/GPG-KEY-Mellanox.pub | sudo gpg --yes --dearmor -o /usr/share/keyrings/doca.gpg
cat <<EOF | sudo tee /etc/apt/sources.list.d/doca.sources
Types: deb
URIs: https://linux.mellanox.com/public/repo/doca/2.9.3/ubuntu24.04/x86_64/
Suites: /
Signed-By: /usr/share/keyrings/doca.gpg
EOF
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/nodesource.gpg
cat <<EOF | sudo tee /etc/apt/sources.list.d/nodesource.sources
Types: deb
URIs: https://deb.nodesource.com/node_24.x
Suites: nodistro
Components: main
Signed-By: /usr/share/keyrings/nodesource.gpg
EOF
cat <<EOF | sudo tee /etc/apt/preferences.d/nodejs
Package: nodejs
Pin: origin deb.nodesource.com
Pin-Priority: 600
EOF

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt -y install doca-all fish neovim tree-sitter-cli python3-pynvim ripgrep fd-find fzf zoxide eza tree jq libarchive-tools luarocks apt-file bmon net-tools rsync git tmux rustup golang python3-dev python3-venv libibverbs-dev libssl-dev rlwrap nodejs cmake redis
sudo ln -srf /usr/bin/fdfind /usr/bin/fd

curl -fsSL https://github.com/jesseduffield/lazygit/releases/download/v0.56.0/lazygit_0.56.0_Linux_x86_64.tar.gz | sudo bsdtar xvf - -C /usr/local/bin lazygit
curl -fsSL https://github.com/MiSawa/xq/releases/download/v0.4.1/xq-v0.4.1-x86_64-unknown-linux-musl.tar.gz | sudo bsdtar xvf - -C /usr/local/bin --strip-components 1 '*/xq'
curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip -dc | sudo tee /usr/local/bin/tree-sitter >/dev/null
curl -fsSL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip | sudo bsdtar xvf - -C /usr/local/bin --strip-components 1 '*/yazi' '*/ya'
curl -fsSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | sudo bsdtar xvf - -C /usr/local/bin k9s
curl -fsSL https://github.com/antonmedv/fx/releases/latest/download/fx_linux_amd64 | sudo tee /usr/local/bin/fx >/dev/null
curl -fsSL https://github.com/medialab/xan/releases/latest/download/xan-x86_64-unknown-linux-musl.tar.gz | sudo bsdtar xvf - -C /usr/local/bin 'xan'
curl -fsSL https://github.com/boyter/scc/releases/latest/download/scc_Linux_x86_64.tar.gz | sudo bsdtar xvf - -C /usr/local/bin 'scc'

sudo chown -R root:root /usr/local/bin/*
sudo chmod a+x /usr/local/bin/*
ls -lah /usr/local/bin/
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 100
sudo update-alternatives --set editor /usr/bin/nvim
sudo chsh -s /usr/bin/fish "$USER"

sudo tic -x ghostty.terminfo
cp -r home/.config ~/
cp -rn home/.ssh ~/
cat home/.ssh/*.pub | tee -a ~/.ssh/authorized_keys

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sudo ibv_devinfo
sudo rdma link show
