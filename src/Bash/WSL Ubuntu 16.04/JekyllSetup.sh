#!/bin/sh
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-jekyll-development-site-on-ubuntu-16-04
sudo apt-get update
sudo apt-get install ruby ruby-dev make gcc
sudo gem install jekyll bundler
# Note: pygments doesn't work on Github Pages
# sudo apt-get install -y python3-pip
# pip3 install --upgrade pip
# pip3 install pygments
# sudo gem install pygments.rb
