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
    msg_log_remove_sudo="Removing kde-service-menu-revideo system wide"
    msg_log_remove_user="Removing kde-service-menu-revideo locally"

    msg_log_remove_bin_dir="removing ${bin_dir}revideo-kdialog"
    msg_log_remove_servicemenu="removing ${servicemenu_dir}/revideo..."
    msg_log_remove_doc_dir="removing ${doc_dir}"

    msg_log_remove_goodbye="kde-service-menu-revideo has been removed. Goodbye 😢"
}

fr_FR () {
    msg_log_remove_sudo="Suppression globale de kde-service-menu-revideo..."
    msg_log_remove_user="Suppression locale de kde-service-menu-revideo..."

    msg_log_remove_bin_dir="Suppression de ${bin_dir}revideo-kdialog"
    msg_log_remove_servicemenu="Suppression de ${servicemenu_dir}/revideo..."
    msg_log_remove_doc_dir="Suppression de ${doc_dir}"

    msg_log_remove_goodbye="kde-service-menu-revideo a bien été supprimé. Adieu... 😢"
}




## main
#
lang=${LANG//.?*/}
type ${lang} &> /dev/null || lang='en_US'
load_strings

# environment variables
qtpaths_bin="${qtpaths_bin:-"qtpaths"}"
user_install_prefix="${user_install_prefix:-"${HOME}/.local"}"

if [[ $EUID -eq 0 ]]; then
    bin_dir="$(${qtpaths_bin} --install-prefix)/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/.*://')"
    doc_dir="$(${qtpaths_bin} --install-prefix)/share/doc/kde-service-menu-revideo/"
    echo "$msg_log_remove_sudo"
else
    bin_dir="${user_install_prefix}/bin"
    servicemenu_dir="$(${qtpaths_bin} --locate-dirs GenericDataLocation kio/servicemenus | sed 's/:.*//')"
    doc_dir="${user_install_prefix}/share/doc/kde-service-menu-revideo/"
    echo "$msg_log_remove_user"
fi

echo "$msg_log_remove_bin_dir"
rm ${bin_dir}/revideo-kdialog

echo "$msg_log_remove_servicemenu"
rm ${servicemenu_dir}/revideo-*


echo "$msg_log_remove_doc_dir
"
rm -rf "${doc_dir}"

echo "$msg_log_remove_goodbye
"
