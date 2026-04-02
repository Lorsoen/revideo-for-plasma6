#! /bin/bash
# set -x # Uncomment for debug
#
# 	Part of kde-service-menu-revideo Version 0.3.0
# 	Copyright (C) 2018-2019 Giuseppe Benigno <giuseppe.benigno(at)gmail.com>
# 	Copyright (C) 2024-2026 Lorsoen <fashim99.(at)gmail.com>
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

#   Credits :
#
#       Script :
#       - Author : Lorsoen
#       - Original author : Giuseppe Benigno
#
#       Translators :
#       - French : Lorsoen
#
#       Special thanks :
#       - Ffmproivsr : https://amiaopensource.github.io/ffmprovisr/#split_audio_video
#       - Ffmpeg Wiki : https://trac.ffmpeg.org/wiki




## language loading
#
load_strings () {
	## Load localized strings AFTER english strings
	## - if localized strings not found use english for default
	## - if localized strings are incomplete use english only fot missing strings :-)
	## - lock_en_US separated and managed by overwrite
	en_US && [ "${lang}" != "en_US" ] && ${lang}
	[ "${overwrite}" = false ] && lock_en_US && [ "${lang}" != "en_US" ] && file_${lang}
}




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
    edition="$msg_init_minimal_inst"
}

set_user_vars () {
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
}

## locale strings
#
#   Translators! If you wish to add a translation:
#    - Copy this chunk of code and paste it just below it.
#    - Change "en_US" to your language code. You can get it :
#        - From your system's language (copy : ' lang=${LANG//.?*/} && echo $lang ' in a terminal, then copy the result
#        - On this webpage : https://learn.microsoft.com/en-us/linkedin/shared/references/reference-tables/language-codes
#    - You're good to go :D  Please test your changes to see if it feels good and works okay.
#
#   Note : This script follows strictly your system language. If you want to force another one :
#    - On the line ' en_US && [ "${lang}" != "en_US" ] && ${lang} ' , remove everything but the first ' en_US ' and change it to your desired language
#    - You can look for it with Ctrl + F, search ' load_strings ' .
#
en_US () {
    msg_init_sudo_caution="
Sudo install for revideo is not recommended if you want the full package!
It will only install the minimal version.

Are you sure you want to proceed?
"
    msg_init_sudo_yes="Yes, proceed anyway!"; msg_init_sudo_no="No, abort mission!"

    msg_init_edition_caution="
revideo has extra AI tools that requires extra installation and a password.
What do you want to do?
"
    msg_init_minimal_inst="Get this AI garbage off my lawn!!!"; msg_init_normal_inst="I'll have some of it..."; msg_init_everything_inst="Everything you have!"

    msg_log_minimal="OK. Beginning 'minimal' install:"
    msg_log_normal="OK. Beginning 'normal' install:"
    msg_log_everything="OK. Beginning 'everything' install:"


    msg_log_install_system="Installing kde-service-menu-revideo on system..."
    msg_log_install_local="Installing kde-service-menu-revideo locally..."
    msg_log_exiting="Exiting install..."

    msg_log_setup_error="ERROR: Required variable ${var} was not set successfully. Aborting..."
    msg_log_edition_error="ERROR: Edition is unknown. Aborting..."
    msg_log_install_success="SUCCESS: kde-service-menu-revideo has been installed successfully."
    msg_log_install_error="ERROR: kde-service-menu-revideo installation failed."
}

fr_FR () {
    msg_init_sudo_caution="
L'installation en tant que super utilisateur n'est pas recommandée si vous voulez
profiter de tous les outils. Seule la version minimale peut-être installée.

Êtes-vous sûr de votre choix ?
"
    msg_init_sudo_yes="Oui, allez-y !"; msg_init_sudo_no="Non, je voulais pas faire ça !"

    msg_init_edition_caution="
revideo peut installer plusieurs paquets optionnels (mot de passe requis)
fournissant des outils complémentaires d'IA. Que souhaitez-vous faire ?
"
    msg_init_minimal_inst="Barrez-vous, cons de bots !!!"; msg_init_normal_inst="Juste un peu..."; msg_init_everything_inst="Tout ce que vous avez !"

    msg_log_minimal="D'accord. Début de l'installation 'minimal' :"
    msg_log_normal="D'accord. Début de l'installation 'normal' :"
    msg_log_everything="D'accord. Début de l'installation 'complet' :"


    msg_log_install_system="Installation globale de kde-service-menu-revideo en cours..."
    msg_log_install_local="Installation locale de kde-service-menu-revideo en cours..."
    msg_log_exiting="Sortie de l'installateur..."

    msg_log_setup_error="ERREUR : La variable « ${var} » n'a pas été crée comme prévu. Abandon..."
    msg_log_edition_error="ERREUR : L'édition est inconnue. Abandon..."
    msg_log_install_success="SUCCESS : kde-service-menu-revideo a été installé avec succès."
    msg_log_install_error="ERREUR : Échec de l'installation de kde-service-menu-revideo."
}





## prompts
#
prompt_sudo () {

# sudo install
if [[ ${EUID} -eq 0 ]]; then
    echo "$msg_init_sudo_caution
    "
    are_you_sure_list=("$msg_init_sudo_yes" "$msg_init_sudo_no")

    select sudo in "${are_you_sure_list[@]}"; do
        case $sudo in
            ("$msg_init_sudo_yes")
                echo "$msg_log_install_system
                "
                set_sudo_vars
                break
                ;;
            ("$msg_init_sudo_no")
                echo "$msg_log_exiting
                "
                exit 1
                ;;
            (*)
                echo "$msg_log_exiting
                "
                exit 1
        esac
    done

# user install
else
    echo "$msg_log_install_local
    "
    set_user_vars
fi
}

prompt_edition () {

    if [[ ${EUID} -ne 0 ]]; then

        echo "$msg_init_edition_caution
        "

        install_list=("$msg_init_minimal_inst" "$msg_init_normal_inst" "$msg_init_everything_inst")
        select edition in "${install_list[@]}"; do
            case $edition in
                ("$msg_init_minimal_inst")
                    echo "$msg_log_minimal
                    "
                    break
                    ;;
                ("$msg_init_normal_inst")
                    echo "$msg_log_normal
                    "
                    break
                    ;;
                ("$msg_init_everything_inst")
                    echo "$msg_log_everything
                    "
                    break
                    ;;
                (*)
                    echo "$msg_log_exiting
                    "
                    exit 1
            esac
        done
    else
        edition="$msg_init_minimal_inst";
    fi
}



## functions
#
func_checkup () {
# ensure all required variables are set
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        load_strings
        echo "$msg_log_setup_error
        "
        exit 1
    fi
done
}

func_install_required () {
    # Binaries
    install -d "${bin_dir}" && \
    install -m 755 -p bin/* "${bin_dir}" && \
    # Documentation files
    install -d "${doc_dir}" && \
    install -m 644 -p doc/* "${doc_dir}"
    # Service menus
    install -d "${servicemenu_dir}" && \
    install -m 755 -p ServiceMenus/*.desktop "${servicemenu_dir}"
}

func_install () {
    case $edition in
        ("$msg_init_minimal_inst")

        # install required files
        func_install_required

        # give installation type tools actions
        sed -i '/Actions=/ s/.*/Actions=_SEPARATOR_;1disassemble_jpg;2disassemble_png;3disassemble_tracks;_SEPARATOR_;5inter;6restore;7deinterlace;8transcript;90audio_split;_SEPARATOR_;92add_music;93add_watermark;_SEPARATOR_;95sepia;96gray/' \
        ${servicemenu_dir}/revideo-tools.desktop

        ;;

        ("$msg_init_normal_inst")

        # install required files
        func_install_required

        # give installation type tools actions
        sed -i '/Actions=/ s/.*/Actions=_SEPARATOR_;1disassemble_jpg;2disassemble_png;3disassemble_tracks;_SEPARATOR_;5inter;6restore;7deinterlace;8transcript;90audio_split;_SEPARATOR_;92add_music;93add_watermark;_SEPARATOR_;95sepia;96gray/' \
        ${servicemenu_dir}/revideo-tools.desktop

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

        ("$msg_init_everything_inst")

        # install required files
        func_install_required

        # give installation type tools actions
        sed -i '/Actions=/ s/.*/Actions=_SEPARATOR_;1disassemble_jpg;2disassemble_png;3disassemble_tracks;_SEPARATOR_;5inter;6restore;7deinterlace;8transcript;90audio_split;_SEPARATOR_;92add_music;93add_watermark;_SEPARATOR_;95sepia;96gray/' \
        ${servicemenu_dir}/revideo-tools.desktop

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
        ##pipx install whisperx
        ;;

        (*)
        echo "$msg_log_edition_error
        "
        exit 1;;

    esac
}




## main
#
lang=${LANG//.?*/}
type ${lang} &> /dev/null || lang='en_US'
load_strings

if (($# == 0)); then

    prompt_sudo
    func_checkup
    prompt_edition
    func_install

else [[ "$1" = "--ffwd" ]] || [[ "$1" = "-f" ]];

    edition="$msg_init_everything_inst"

    if [[ ${EUID} -eq 0 ]]; then
        echo "$msg_log_install_system
        "
        set_sudo_vars
    else
        echo "$msg_log_install_local
        "
        set_user_vars
    fi

    func_checkup
    func_install
fi

# report installation result
if [ ${?} -eq 0 ]; then
    echo "$msg_log_install_success
    "
else
    echo "$msg_log_install_error
    "
    exit 1
fi
