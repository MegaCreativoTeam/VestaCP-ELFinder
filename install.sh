#!/bin/bash

# Official VestaCP El Finder - File Manager Installation Script
# =============================================
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Supported Operating Systems:
# CentOS 6/7/8 Minimal
# Ubuntu server 14.04/18.04
# Debian 7/8
# 32bit and 64bit
#

INSTALLER_VERSION="1.0.0"
CORE_VERSION="master"
PACKAGE="VestaCP-ELFinder-$CORE_VERSION"

h1() {
    echo -e "\e[1m\e[34m$1\e[0m"
}

h2() {
    echo -e "\n\e[21m\e[94m$1\e[0m"
}

success() {
    echo -e "\e[42m\e[4m[Done]\e[0m $1"
}

failed() {
    echo -e "\e[41m\e[4m[Fail]\e[0m $1"
}


# Am I root?
isRoot(){
    if [ "x$(id -u)" != 'x0' ]; then
        echo_failed 'Error: this script can only be executed by root'
        exit 1
    fi
}

#--- Display the 'welcome' splash/user warning info..
welcome(){
    clear
    echo ""
    h1 ""
    h1 "    __     _______ _     _____  "
    h1 "    \ \   / / ____| |   |  ___| "
    h1 "     \ \ / /|  _| | |   | |_    "
    h1 "      \ V / | |___| |___|  _|   "
    h1 "       \_/  |_____|_____|_|     "
    echo ""
    echo "VestaCP El Finder - File Manager"
    echo "File Manager for VestaCP"
    echo ""
    echo "Copyright © 2020. Powered By Mega Creativo <http://megacreativo.com>"
    echo ""
}

download(){
    h2 "Downloading VELF, Please wait, the installer will continue after this is complete!"

    cd /usr/local/vesta/web/list
    wget -q https://github.com/megacreativo/VestaCP-ELFinder/archive/master.zip -O velf.zip
    unzip -q velf.zip
    cd $PACKAGE
    mv elfm ../ && cd ..
    rm -rf $PACKAGE
    rm -rf velf.zip

    success "Downloaded VELF"
}


# Add the link to the panel.html file 
install(){

    h2 "Installing VELF"

    if grep -q "velf" /usr/local/vesta/web/templates/admin/panel.html; then
        success "VestaCP El Finder it already exists"
    else 
        sed -i '/<div class="l-menu clearfix noselect">/a <div class="l-menu__item <?php if($TAB == "velf" ) echo "l-menu__item--active"; ?>"><a href="/list/velf/" target="_blank"><?=__("Finder")?></a></div>' /usr/local/vesta/web/templates/admin/panel.html;
    fi

    success "VestaCP El Finder is Active"
}

setup(){
    isRoot
    welcome
    read -p "You want to install VestaCP El Finder? [y:Yes/n:No]: (y)" PROCESS
    if [[ "$PROCESS" = "y" ]]; then
        download
        install
    fi
}

setup