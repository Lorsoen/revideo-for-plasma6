#! /bin/bash
#
# 	Part of kde-service-menu-revideo Version 0.1.2
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

# determine installation directories
if [[ ${EUID} -eq 0 ]]; then
    bin_dir="$(${qtpaths_bin} --install-prefix)/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/.*://')"
    doc_dir="$(${qtpaths_bin} --install-prefix)/share/doc/kde-service-menu-revideo/"
    model_dir="$(${qtpaths_bin} --install-prefix)/usr/share"
    install_mode="system"
else
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
    model_dir="$(${qtpaths_bin} --install-prefix)/usr/share"
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

# install documentation files
install -d "${doc_dir}" && \
install -m 644 -p doc/* "${doc_dir}"
# install extra dependencies

    printf "revideo comes with extra AI tools that requires extra installation.
    "
    printf "Which install do you want to do ?
    
    "
    install_type=' '
    install_list=("\"Get this AI garbage off my lawn!!!\"" "\"I'll have some of it...\"" "\"Everything you have!\"")
    select fav in "${install_list[@]}"; do
        case $fav in
            ("\"Get this AI garbage off my lawn!!!\"")
                echo "OK. Beginning minimal install:"
                sleep 0.8
                install -d "${servicemenu_dir}" && \
                install -m 755 -p ServiceMenus/minimal/*.desktop "${servicemenu_dir}" && \
                
                break
                ;;
            ("\"I'll have some of it...\"")
                echo "OK. Beginning normal install:"
                sleep 0.8
                install -d "${servicemenu_dir}" && \
                install -m 755 -p ServiceMenus/normal/*.desktop "${servicemenu_dir}" && \
                
                # Video Restoration
                pipx install waifu2x-ncnn-vulkan-python

                # Video Upscale
                pipx install waifu2x-ncnn-vulkan-python

                # Interpolation
                pipx install rife-ncnn-vulkan-python

                # Audio separation
                pipx install openunmix
    
                # Transcript
                pipx install whisperx
                
                break
                ;;
            ("\"Everything you have!\"")
                echo "OK. Beginning everything install:"
                sleep 0.8
                install -d "${servicemenu_dir}" && \
                install -m 755 -p ServiceMenus/everything/*.desktop "${servicemenu_dir}" && \
                
                # Video Restoration
                pipx install waifu2x-ncnn-vulkan-python

                # Video Upscale
                pipx install srmd-ncnn-vulkan-python
                pipx install waifu2x-ncnn-vulkan-python

                # Interpolation
                wget https://github.com/nihui/rife-ncnn-vulkan/releases/download/20221029/rife-ncnn-vulkan-20221029-ubuntu.zip
                wget https://github.com/nihui/dain-ncnn-vulkan/releases/download/20220728/dain-ncnn-vulkan-20220728-ubuntu.zip

                # Audio separation
                pipx install openunmix
    
                # Transcript
                pipx install openai-whisper
                pipx install whisperx
                
                break
                ;;
            (*) echo "Invalid option $REPLY";;
        esac
    done

if [[ $CHECK1 = "" ]]; then

# report installation result
if [ ${?} -eq 0 ]; then
    echo "SUCCESS: kde-service-menu-revideo has been installed successfully."
else
    echo "ERROR: kde-service-menu-revideo installation failed."
    exit 1
fi
