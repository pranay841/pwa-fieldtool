#!/bin/bash

DIR="/workspace/pwa-deals/@hbwsl"
if [ ! -d "$DIR" ]; then
    #removing module files from root
    folders=(.github src)
    files=(.gitignore .editorconfig .eslintrc.js babel.config.json jest.config.js package.json prettier.config.js yarn.lock README.md)

    for files in "${folders[@]}"; do
        rm -r -f "$files"
    done
    for file in "${files[@]}"; do
        rm -f "$file"
    done

# https://magento.github.io/pwa-studio/venia-pwa-concept/setup/


rm -rf /workspace/magento2gitpod/node_modules
rm -rf /workspace/magento2gitpod/.npm

export NVM_DIR=/workspace/pwa-deals/nvm
mkdir -p $NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
. "$NVM_DIR/nvm.sh"
nvm install 16.14.0
nvm use 16.14.0
npm install yarn -g
npm install rimraf -g

cd /workspace/pwa-fieldtool && sudo apt update && sudo apt -y install expect

chmod a+rwx /workspace/pwa-fieldtool/initialize-theme.sh
chmod a+rwx /workspace/pwa-fieldtool/install-theme.exp &&
/workspace/pwa-fieldtool/install-theme.exp

cd /workspace/pwa-fieldtool/fieldtooldev && cp -avr .* /workspace/pwa-fieldtool;
cd /workspace/pwa-fieldtool && rm -r -f fieldtooldev;
cd /workspace/pwa-fieldtool

mkdir /workspace/pwa-fieldtool/@humcommerce && cd /workspace/pwa-fieldtool/@humcommerce

ORIGIN_VALUE=$(git config --get remote.origin.url)

git clone $ORIGIN_VALUE && mv pwa-fieldtool fieldtool
cd /workspace/pwa-fieldtool && rm -rf .git
sed -i 's/_SERVER_PORT=0/_SERVER_PORT=10000/g' /workspace/pwa-fieldtool/.env

yarn add sass sass-loader@^10.1.1 link:./@humcommerce/fieldtool

WEBPACK_CONFIG_EXT="config.module.rules.push({test: /\\.s[ca]ss$/,use: ['style-loader',{loader: require.resolve('css-loader'),options: {importLoaders: 1,modules: true,modules : {localIdentName: '[name]__[local]__[hash:base64:3]',},},},'sass-loader']});"
sed  -i".bak" -e  "/return \[config\]/i $WEBPACK_CONFIG_EXT" /workspace/pwa-fieldtool/webpack.config.js
yarn install && yarn run build && yarn run start
fi
