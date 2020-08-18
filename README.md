# Clash Premiun Installer

Simple clash premiun core installer with full tun support for Linux.

### Introduction

Seeking for a solution to install clash automatically, I discover [Clash Premiun Installer by Kr328](https://github.com/Kr328/clash-premium-installer/).

It is very convenient, but some settings do not work on Fedora. So I fork it and make some modifications

### Usage

- Clone installer
  ```bash
  git clone git@github.com:suiahae/clash-premium-installer.git
  cd clash-premium-installer
  ```

- Download clash core [link](https://github.com/Dreamacro/clash/releases/tag/premium)

- Uncompress clash core and rename it to `./clash`

- The default clash is clash-linux-amd64-2020.06.27.gz

- Run Installer
  ```bash
  sudo ./installer.sh install
  ```
