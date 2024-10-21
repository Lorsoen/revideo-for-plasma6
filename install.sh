#! /bin/bash
#
# 	Part of kde-service-menu-revideo Version 2.5
# 	Copyright (C) 2018-2019 Giuseppe Benigno <giuseppe.benigno(at)gmail.com>
#   Copyright (C) 2024 <fashim99.(at)gmail.com>
#
# 	This program is free software: you can redistribute it and/or modify
# 	it under the terms of the GNU General Public License as published by
# 	the Free Software Foundation, either version 3 of the License, or
# 	(at your option) any later version.
#
# 	This program is distributed in the hope that it will be useful,
# 	but WITHOUT ANY WARRANTY; without even the implied warranty of
# 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# 	GNU General Public License for more details.
#
# 	You should have received a copy of the GNU General Public License
# 	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#if [[ $EUID -eq 0 ]]; then
#    bin_dir="$(kf5-config --path exe | sed "s/.*://")"
#    desktop_dir="$(kf5-config --path services | sed "s/.*://")ServiceMenus/"
#    doc_dir="$(kf5-config --prefix)/share/doc/kde-service-menu-revideo/"
#    echo "Installing kde-service-menu-reimage system wide"
#else
#    bin_dir="$HOME/bin"
#    desktop_dir="$(kf5-config --path services | sed "s/:.*//")"
#    doc_dir=$HOME"/share/doc/kde-service-menu-reimage/"
#    echo "Installing kde-service-menu-reimage locally"
#fi
#
### INSTALLING
## if [ ! -d "${bin_dir}" ]; then
##     echo "Making directory ${bin_dir}"
##     mkdir -p "${bin_dir}"
## fi
## echo "Copy files to ${bin_dir}"
## cp bin/encfs-kdialog ${bin_dir}
##
## if [ ! -d "${desktop_dir}" ]; then
##     echo "Making directory ${desktop_dir}"
##     mkdir -p "${desktop_dir}"
## fi
## echo "Copy files to ${desktop_dir}"
## cp ServiceMenus/encfs.desktop ${desktop_dir}
##
## if [ ! -d "${doc_dir}" ]; then
##     echo "Making directory ${doc_dir}"
##     mkdir -p "${doc_dir}"
## fi
## echo "Copy files to ${doc_dir}"
## cp doc/* ${doc_dir}
#
#sudo install -m 755 bin/* "${bin_dir}"
#sudo install -m 644 ServiceMenus/*.desktop "${desktop_dir}"
#sudo install -d "${doc_dir}"
#sudo install -m 644 doc/* "${doc_dir}"
#
#echo "Done!. kde-service-menu-revideo has been installed. Enjoy!"




# environment variables
qtpaths_bin="${qtpaths_bin:-"qtpaths"}"
user_install_prefix="${user_install_prefix:-"${HOME}/.local"}"

# local variables
required_vars=("bin_dir" "servicemenu_dir" "doc_dir")

# determine installation directories
if [[ ${EUID} -eq 0 ]]; then
    bin_dir="$(${qtpaths_bin} --install-prefix)/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/.*://')"
    doc_dir="$(${qtpaths_bin} --install-prefix)/share/doc/kde-service-menu-revideo/"
    install_mode="system"
else
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
    install_mode="local"
fi

# ensure all required variables are set
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "ERROR: Required variable ${var} was not set successfully. Aborting installation of kde-service-menu-revideo."
        exit 1
    fi
done

echo "Installing kde-service-menu-revideo (${install_mode}) ..."

# install required binaries
install -d "${bin_dir}" && \
install -m 755 -p bin/* "${bin_dir}" && \
# install required service menus
install -d "${servicemenu_dir}" && \
install -m 755 -p ServiceMenus/*.desktop "${servicemenu_dir}" && \
# install documentation files
install -d "${doc_dir}" && \
install -m 644 -p doc/* "${doc_dir}"

# report installation result
if [ ${?} -eq 0 ]; then
    echo "SUCCESS: kde-service-menu-revideo has been installed successfully."
else
    echo "ERROR: kde-service-menu-revideo installation failed."
    exit 1
fi
