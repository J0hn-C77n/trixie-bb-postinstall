#!/bin/bash
echo 'deb http://download.opensuse.org/repositories/home:/cabelo/Debian_Testing/ /' | sudo tee /etc/apt/sources.list.d/home:cabelo.list
curl -fsSL https://download.opensuse.org/repositories/home:cabelo/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_cabelo.gpg > /dev/null
sudo apt update
sudo apt install zap
