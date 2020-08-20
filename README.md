# Clash Premiun Installer

Simple clash premiun core installer with full tun support for Linux.

### Introduction

Seeking for a solution to install clash automatically, I discover [Clash Premiun Installer by Kr328](https://github.com/Kr328/clash-premium-installer/).

It is very convenient, but some settings(udev.rules) do not work on Fedora. So I fork it and make some modifications

### Usage

- Clone installer
  ```bash
  git clone git@github.com:suiahae/clash-premium-installer.git
  cd clash-premium-installer
  ```

- The default clash is clash-linux-amd64-2020.08.16.gz

- [Optional] You can also download clash core at [link](https://github.com/Dreamacro/clash/releases/tag/premium) , uncompress clash core and rename it to `./clash`

- Run Installer
  ```bash
  sudo ./installer.sh install
  ```
