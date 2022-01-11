#!/usr/bin/env bash

# Licensed under GNU GPL 2.0 by Ingo "ninelore" Reitz <ninelore@protonmail.com>
# Version 1v9-3

###########################################################################
## Adjust below!
###########################################################################

# Path to Arma's compatdata (wineprefix)
# Leave default if Arma was installed in Steams default directory
COMPAT_DATA_PATH="$HOME/.local/share/Steam/steamapps/compatdata/107410"
# Proton Version (folder name in compatibilitytools.d)
PROTONVERSION="proton_tkg_6.0rc4.r3.g0e67af3d.9l-arma"

###########################################################################
## DO NOT EDIT BELOW!
###########################################################################

# Enviromentals
export STEAM_COMPAT_DATA_PATH="$COMPAT_DATA_PATH" 
export PROTON_NO_ESYNC="1" 
export SteamAppId="107410"
export SteamGameId="107410" 
export LD_PRELOAD="$HOME/.local/share/Steam/ubuntu12_64/gameoverlayrenderer.so"

# help
if [[ $1 == "help" ]]; then
	echo "SCRIPT USAGE"
	echo
	echo "Start TS: ./Arma3TS.sh"
	echo 
	echo "Install TS: ./Arma3TS.sh install [installer exe path]"
	echo
	echo "Help: ./Arma3TS.sh help"
fi

# install
if [[ $1 == "install" ]]; then
	echo "Trying to install Teamspeak with provided file"
	if [[ -z $2 ]]; then
		echo "Error - no installer exe provided"
	fi
	$PROTONEXEC run $2
fi

# Executable Paths
PROTONEXEC="$HOME/.local/share/Steam/compatibilitytools.d/$PROTONVERSION/proton"
TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program\ Files/TeamSpeak\ 3\ Client/ts3client_win64.exe"

# The Command
if [[ -z $@ ]]; then
	sh -c "$PROTONEXEC run $TSPATH"
fi
if [[ $1 = "debug" ]]; then
	echo "sh -c \"$PROTONEXEC run $TSPATH\""
fi
## EOF
