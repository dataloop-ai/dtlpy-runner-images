cd /tmp
{
    code-server --version
} || {
    echo "install code-server"
    echo "starting"
    curl -fsSL -o /tmp/nvm-install.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh
    bash /tmp/nvm-install.sh
    rm /tmp/nvm-install.sh
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 22
    npm install -g yarn
    yarn global add code-server@4.112.0
    export PATH="$(yarn global bin):$PATH"
    code-server --install-extension ms-python.python
}
