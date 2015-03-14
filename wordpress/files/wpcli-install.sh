#!/bin/bash

#Downloading wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#Installing wp-cli
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp