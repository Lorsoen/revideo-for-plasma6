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
    printf "Sudo install for revideo is not recommended if you want the full package! \n"
    printf "It will only install the minimal version. \n\n"
    printf "Are you sure you want to proceed ? \n\n"
    are_you_sure_list=("Yes, proceed anyway!" "No, abort mission!")
    select inst in "${are_you_sure_list[@]}"; do
        case $inst in
            ("Yes, proceed anyway!")
                bin_dir="$(${qtpaths_bin} --install-prefix)/bin"
                servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/.*://')"
                doc_dir="$(${qtpaths_bin} --install-prefix)/share/doc/kde-service-menu-revideo/"
                install_mode="system"
                install_list=("Get this AI garbage off my lawn!!!" "I'll have some of it..." "Everything you have!")
                #fav="Get this AI garbage off my lawn!!!"
                break
                ;;
            ("No, abort mission!")
                echo "Exiting install..."
                exit 1
                ;;
            (*) echo "Exiting install..."
                exit 1
        esac
    done
    
else
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
    install_mode="local"
    install_list=("Get this AI garbage off my lawn!!!" "I'll have some of it..." "Everything you have!")
fi

# ensure all required variables are set
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "ERROR: Required variable ${var} was not set successfully. Aborting installation of kde-service-menu-revideo."
        exit 1
    fi
done

if [[ ${EUID} -eq 0 ]]; then
    echo "Installing kde-service-menu-revideo (${install_mode}) ..."

    printf "revideo comes with extra AI tools that requires extra installation. \n\n"
    printf "Which install do you want to do ? \n"  

    select fav in "${install_list[@]}"; do
        break
    done
fi

case $fav in
    ("Get this AI garbage off my lawn!!!")
        echo "OK. Beginning minimal install:"

        # install required binaries
        install -d "${bin_dir}" && \
        install -m 755 -p bin/* "${bin_dir}" && \
        # install documentation files
        install -d "${doc_dir}" && \
        install -m 644 -p doc/* "${doc_dir}"
        # install service menus
        install -d "${servicemenu_dir}" && \
        install -m 755 -p ServiceMenus/minimal/*.desktop "${servicemenu_dir}" && \
        sleep 0.01
        ;;

    ("I'll have some of it...")
        echo "OK. Beginning normal install:"

        # install required binaries
        install -d "${bin_dir}" && \
        install -m 755 -p bin/* "${bin_dir}" && \
        # install documentation files
        install -d "${doc_dir}" && \
        install -m 644 -p doc/* "${doc_dir}"
        # install service menus
        install -d "${servicemenu_dir}" && \
        install -m 755 -p ServiceMenus/normal/*.desktop "${servicemenu_dir}" && \
        # install extra dependencies
        
        # Package managers
        sudo pacman -S --noconfirm --quiet yay
        sudo pacman -S --noconfirm --quiet python-pipx
        # Video Restoration
        yay -S --noconfirm --quiet realesrgan-ncnn-vulkan
        # Video Upscale
        yay -S --noconfirm --quiet srmd-ncnn-vulkan-bin
        # Interpolation
        yay -S --noconfirm --quiet rife-ncnn-vulkan-bin
        # Audio separation
        pipx install openunmix
        # Transcript
        pipx install whisperx
        ;;      

    ("Everything you have!")
        echo "OK. Beginning everything install:"
        
        # install required binaries
        install -d "${bin_dir}" && \
        install -m 755 -p bin/* "${bin_dir}" && \
        # install documentation files
        install -d "${doc_dir}" && \
        install -m 644 -p doc/* "${doc_dir}"
        # install service menus
        install -d "${servicemenu_dir}" && \
        install -m 755 -p ServiceMenus/everything/*.desktop "${servicemenu_dir}" && \
        # install extra dependencies

        # Package managers
        #sudo pacman -S --noconfirm --quiet yay
        #sudo pacman -S --noconfirm --quiet python-pipx
        ## Video Restoration
        #yay -S --noconfirm --quiet realesrgan-ncnn-vulkan
        ## Video Upscale
        #yay -S --noconfirm --quiet srmd-ncnn-vulkan-bin
        #yay -S --noconfirm --quiet realsr-ncnn-vulkan-python
        ## Interpolation
        #yay -S --noconfirm --quiet rife-ncnn-vulkan-bin
        #yay -S --noconfirm --quiet dain-ncnn-vulkan-bin
        ## Audio separation
        #pipx install openunmix
        ## Transcript
        #pipx install openai-whisper
        pipx install whisperx
        ;;    

    (*) 
        echo "Exiting install..."
        exit 1;;

esac

# report installation result
if [ ${?} -eq 0 ]; then
    echo "SUCCESS: kde-service-menu-revideo has been installed successfully."
else
    echo "ERROR: kde-service-menu-revideo installation failed."
    exit 1
fi