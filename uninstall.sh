#! /bin/bash
#
# 	Part of kde-service-menu-revideo Version 0.2.0
# 	Copyright (C) 2018-2019 Giuseppe Benigno <giuseppe.benigno(at)gmail.com>
# 	Copyright (C) 2024 <fashim99.(at)gmail.com>
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

# environment variables
qtpaths_bin="${qtpaths_bin:-"qtpaths"}"
user_install_prefix="${user_install_prefix:-"${HOME}/.local"}"

# local variables
required_vars=("bin_dir" "servicemenu_dir" "doc_dir")

if [[ $EUID -eq 0 ]]; then
    bin_dir="$(${qtpaths_bin} --install-prefix)/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/.*://')"
    doc_dir="$(${qtpaths_bin} --install-prefix)/share/doc/kde-service-menu-revideo/"
    echo "Removing kde-service-menu-revideo system wide"
else
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
    echo "Removing kde-service-menu-revideo locally"
fi

echo "removing ${bin_dir}revideo-kdialog"
rm "${bin_dir}/revideo-kdialog"

echo "removing ${servicemenu_dir}/revideo-compress-resize.desktop"
rm "${servicemenu_dir}/revideo-compress-resize.desktop"
echo "removing ${servicemenu_dir}/revideo-convert-rotate.desktop"
rm "${servicemenu_dir}/revideo-convert-rotate.desktop"
echo "removing ${servicemenu_dir}/revideo-metadata.desktop"
rm "${servicemenu_dir}/revideo-metadata.desktop"
echo "removing ${servicemenu_dir}/revideo-tools.desktop"
rm "${servicemenu_dir}/revideo-tools.desktop"

echo "removing ${doc_dir}"
rm -rf "${doc_dir}"

echo
echo "kde-service-menu-revideo has been removed. Goodbye 😢"
