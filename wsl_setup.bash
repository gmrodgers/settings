#!/usr/bin/env bash

set -exuo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function update_dist {
  apt-get update
  apt-get upgrade
  apt-get dist-upgrade
}

function install_prequisites {
  apt-get install software-properties-common <<< $'Y'
  apt-get install build-essential python-dev python-pip python3-dev python3-pip <<< $'Y'
  add-apt-repository ppa:neovim-ppa/stable <<< $'\n'
}

function install_packages {
  wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
  chmod +x diff-so-fancy
  mv diff-so-fancy /bin/diff-so-fancy

  wget https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb
  dpkg -i bat_0.11.0_amd64.deb
  rm bat_0.11.0_amd64.deb

  wget https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
  dpkg -i ripgrep_11.0.1_amd64.deb
  rm ripgrep_11.0.1_amd64.deb

  apt-get install \
    curl \
    file \
    git \
    python3 \
    source-highlight \
    lastpass-cli \
    autojump \
    gpg \
    shellcheck \
    sshuttle \
    thefuck \
    vim \
    wget \
    jq \
    direnv \
    neovim \
    npm \
    tree \
    grip \
    tmux <<< $'Y'
}

function add_git {
  lpass show --notes private_key > "${HOME}/.ssh/id_rsa"
  chmod 0400 "${HOME}/.ssh/id_rsa"
  eval "$(ssh-agent -s)"
  ssh-add "${HOME}/.ssh/id_rsa"

  git config --global user.email "$1"
  git config --global user.name "$2"
}

function install_luanvim {
  if [[ ! -d "${HOME}/.vim" ]] ; then
    git clone https://github.com/luan/vimfiles.git "${HOME}/.vim"
  fi
  (
    cd "${HOME}/.vim"
    git checkout master
    git pull --rebase <<< $'yes'
    ./update
  )
}

function install_npm_packages {
  npm install -g elm
  npm install -g elm-format
  npm install -g elm-test
}

function install_vscode_extensions {
  xargs -n 1 -t code --install-extension < vscode_extensions.txt
}

function update_configs {
  cp "${dir}/.vimrc.local.plugins" "${HOME}/.vimrc.local.plugins"
  cp "${dir}/.tmux.conf" "${HOME}/.tmux.conf"
  cp "${dir}/.inputrc" "${HOME}/.inputrc"
  cp "${dir}/.gitconfig_global" "${HOME}/.gitconfig"

  echo "source /usr/share/autojump/autojump.bash" >> "${HOME}/.bashrc"
  chmod 0755 /usr/share/autojump/autojump.bash

  echo """
alias 'vim'='nvim'
alias 'ff'='fuck'
alias 'da'='direnv allow'
  """ >> "${HOME}/.bashrc"
}

function cleanup {
  apt-get autoremove <<< $'Y'
}

update_dist
install_prequisites
install_packages
add_git "$@"
install_luanvim
install_npm_packages
# install_vscode_extensions
update_configs
cleanup

