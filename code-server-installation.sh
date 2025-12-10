cd /tmp
{
    code-server --version
} || {
    echo "install code-server"
    echo "starting"
    python3 -c "import requests; r = requests.get('https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh'); open('install.sh', 'w').write(r.text)"
    bash install.sh
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 16
    npm install -g yarn
    yarn global add code-server@4.16.1
    export PATH="$(yarn global bin):$PATH"
    code-server --install-extension ms-python.python
}