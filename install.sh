#! /bin/bash
#
# 	Part of kde-service-menu-revideo Version 0.3.0
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

#
# Credits :
# - Script author : Lorsoen
# - Original reimage script author : Giuseppe Benigno
#
# Special thanks :
# - Ffmproivsr : https://amiaopensource.github.io/ffmprovisr/#split_audio_video
# - Ffmpeg Wiki : https://trac.ffmpeg.org/wiki




# language loading
#
load_strings () {
    cr="
    "
	## Load localized strings AFTER english strings
	## - if localized strings not found use english for default
	## - if localized strings are incomplete use english only fot missing strings :-)
	## - lock_en_US separated and managed by overwrite
	en_US && [ "${lang}" != "en_US" ] && ${lang}
	[ "${overwrite}" = false ] && lock_en_US && [ "${lang}" != "en_US" ] && file_${lang}
}

lang=${LANG//.?*/}
type load_strings_${lang} &> /dev/null || lang='en_US'
load_strings




## variables
#
qtpaths_bin="${qtpaths_bin:-"qtpaths"}"
user_install_prefix="${user_install_prefix:-"${HOME}/.local"}"

# local variables
required_vars=("bin_dir" "servicemenu_dir" "doc_dir")

set_sudo_vars () {
    bin_dir="$(${qtpaths_bin} --install-prefix)/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/.*://')"
    doc_dir="$(${qtpaths_bin} --install-prefix)/share/doc/kde-service-menu-revideo/"
    install_mode="system"
    edition="Get this AI garbage off my lawn!!!"
}

set_user_vars () {
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
    install_mode="local"
}

# strings
en_US () {
    msg_edition_caution="revideo comes with extra AI tools that requires extra installation.${cr}Which install do you want to do ?${cr}${cr}"
    msg_minimal_inst="Get this AI garbage off my lawn!!!"; msg_normal_inst="I'll have some of it..."; msg_everything_inst="Everything you have!"

    msg_init_minimal="OK. Beginning \"minimal\" install:"
    msg_init_normal="OK. Beginning \"normal\" install:"
    msg_init_everything="OK. Beginning \"everything\" install:"

    msg_sudo_caution="Sudo install for revideo is not recommended if you want the full package!${cr}It will only install the minimal version.${cr}Are you sure you want to proceed?${cr}${cr}"
    msg_sudo_yes="Yes, proceed anyway!"; msg_sudo_no="No, abort mission!"

    msg_setup_error="ERROR: Required variable ${var} was not set successfully. Aborting installation of kde-service-menu-revideo."
    msg_edition_error="ERROR: Edition is unknown. Aborting..."
    msg_install_success="SUCCESS: kde-service-menu-revideo has been installed successfully."
    msg_install_error="ERROR: kde-service-menu-revideo installation failed."
}




## heart of the process
#
if (($# == 0)); then

    prompt_sudo
    func_checkup
    prompt_edition
    func_install

else [[ "$1" = "--ffwd" ]];

    set_sudo_vars
    sudo="$msg_sudo_yes"
    edition="$msg_everything_inst"
    func_checkup
    install
fi

# report installation result
if [ ${?} -eq 0 ]; then
    printf $msg_install_success
else
    printf $msg_install_error
    exit 1
fi


## functions
#
prompt_sudo () {
# determine installation directories

# sudo install
if [[ ${EUID} -eq 0 ]]; then
    printf $msg_sudo_caution
    are_you_sure_list=("$msg_sudo_yes" "$msg_sudo_no")

    select sudo in "${are_you_sure_list[@]}"; do
        case $sudo in
            ("$msg_sudo_yes")
                set_sudo_vars
                break
                ;;
            ("$msg_sudo_no")
                echo "Exiting install..."
                exit 1
                ;;
            (*) echo "Exiting install..."
                exit 1
        esac
    done

# user install
else
    set_user_vars
fi
}

prompt_edition () {
    if [[ ${EUID} -eq 1 ]]; then
        echo "Installing kde-service-menu-revideo (${install_mode}) ..."

        printf $msg_edition_caution

        install_list=("$msg_minimal_inst" "$msg_normal_inst" "$msg_everything_inst")

        select edition in "${install_list[@]}"; do

        break
    done
    fi
}

func_checkup () {
# ensure all required variables are set
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        load_strings
        printf $msg_setup_error
        exit 1
    fi
done
}

func_install () {
    case $edition in
    ("$msg_minimal_inst")
        printf $msg_init_minimal

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

    ("$msg_normal_inst")
        printf $msg_init_normal

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
        # Video Upscale
        yay -S --noconfirm --quiet srmd-ncnn-vulkan-bin
        yay -S --noconfirm --quiet realesrgan-ncnn-vulkan_bin
        # Interpolation
        yay -S --noconfirm --quiet rife-ncnn-vulkan-bin
        # Audio separation
        #pipx install openunmix
        # Transcript
        #pipx install whisperx
        ;;

    ("$msg_everything_inst")
        printf $msg_init_everything

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
        ### Video Upscale
        #yay -S --noconfirm --quiet srmd-ncnn-vulkan-bin
        #yay -S --noconfirm --quiet realsr-ncnn-vulkan-bin
        #yay -S --noconfirm --quiet realesrgan-ncnn-vulkan_bin
        ### Interpolation
        #yay -S --noconfirm --quiet rife-ncnn-vulkan-bin
        ### Audio separation
        ##pipx install openunmix
        ### Transcript
        ##pipx install openai-whisper
        pipx install whisperx
        ;;

    (*)
        printf $msg_edition_error
        exit 1;;

    esac
}
