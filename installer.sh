#!/bin/bash

PREFIX=/usr/local

cd "`dirname $0`"

function assert() {
    "$@"

    if [ "$?" != 0 ]; then
    echo "Execute $@ failure"
    exit 1
    fi
}

function assert_command() {
    if ! which "$1" > /dev/null 2>&1;then
    echo "Command $1 not found"
    exit 1
    fi
}

function _install() {
    assert_command install
    assert_command iptables
    assert_command ip
    assert_command install

    if [ ! -d "/usr/lib/udev/rules.d" ];then
    echo "udev not found"
    exit 1
    fi

    if [ ! -d "/usr/lib/systemd/system" ];then
    echo "systemd not found"
    exit 1
    fi

    if [ ! -d "/sys/fs/cgroup/net_cls" ];then
    echo "cgroup not support net_cls"
    exit 1
    fi

    if [ ! -f "./clash" ];then
    echo "Clash core not found."
    echo "Please download it from https://github.com/Dreamacro/clash/releases/tag/premium, and rename to ./clash"
    fi

    assert install -d -m 777 /usr/local/etc/clash

    assert install -d -m 755 $PREFIX/lib/clash

    assert install -m 755 ./clash $PREFIX/bin/clash

    assert install -m 0755 scripts/bypass-proxy-pid $PREFIX/bin/bypass-proxy-pid
    assert install -m 0755 scripts/bypass-proxy $PREFIX/bin/bypass-proxy

    assert install -m 0755 scripts/setup-tun-modified.sh $PREFIX/lib/clash/setup-tun.sh
    assert install -m 0755 scripts/clean-tun-modified.sh $PREFIX/lib/clash/clean-tun.sh
    # assert install -m 0755 scripts/setup-tun.sh $PREFIX/lib/clash/setup-tun.sh
    # assert install -m 0755 scripts/clean-tun.sh $PREFIX/lib/clash/clean-tun.sh
    assert install -m 0755 scripts/setup-cgroup.sh $PREFIX/lib/clash/setup-cgroup.sh

    assert install -m 0644 scripts/clash.service /usr/lib/systemd/system/clash.service
    # assert install -m 0644 scripts/clash-with-udev.service /usr/lib/systemd/system/clash.service
    # assert install -m 0644 scripts/99-clash.rules /etc/udev/rules.d/99-clash.rules
    systemctl daemon-reload

    echo "Install successfully"
    echo ""
    echo "Home directory on /usr/local/etc/clash/"
    echo ""
    echo "Use 'sudo systemctl start clash' to start"
    echo "Use 'sudo systemctl status clash' to show the service informations"
    echo "Use 'sudo systemctl enable clash' to enable auto-restart on boot"

    exit 0
}

function _uninstall() {
    assert_command systemctl
    assert_command rm

    systemctl stop clash
    systemctl disable clash

    rm -rf /usr/lib/clash
    rm -rf /usr/lib/systemd/system/clash.service
    rm -rf /usr/lib/udev/rules.d/99-clash.rules
    rm -rf /usr/bin/clash
    rm -rf /usr/bin/bypass-proxy-uid
    rm -rf /usr/bin/bypass-proxy

    echo "Uninstall successfully"

    exit 0
}

function _help() {
    echo "Clash Premiun Installer"
    echo ""
    echo "Usage: ./installer.sh [option]"
    echo ""
    echo "Options:"
    echo "  install      - install clash premiun core"
    echo "  uninstall    - uninstall installed clash premiun core"
    echo ""

    exit 0
}

case "$1" in
"install") _install;;
"uninstall") _uninstall;;
*) _help;
esac
