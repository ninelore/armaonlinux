#!/usr/bin/env bash

# Licensed under CC BY-SA 4.0 by Ingo "ninelore" Reitz <ninelore@protonmail.com>
# https://creativecommons.org/licenses/by-sa/4.0/ 
# Thanks to: G4rrus#3755 (testing)

# Version 1v13-2

###########################################################################
## Adjust below!
###########################################################################

# Path to Arma's compatdata (wineprefix)
# Leave default if Arma was installed in Steams default directory
STEAM_LIBRARY_PATH="$HOME/home2/SteamLibrary/steamapps/compatdata/107410"

## MAKE SURE THIS IS THE SAME AS THE PROTON VERSION OF ARMA IN STEAM!!!
# Set this to the Proton Version u are using with Arma!
PROTON_OFFICIAL_VER="6.3"
# Set to true if you want to use custom proton in the compatibilitytoold.d folder
USE_OWN_PROTONVERSION=false
# Proton version (folder name in compatibilitytools.d)
PROTON_CUSTOM_VERSION=""

###########################################################################
## DO NOT EDIT BELOW!
###########################################################################

# Enviromentals
export STEAM_COMPAT_DATA_PATH="$COMPAT_DATA_PATH" 
export PROTON_NO_ESYNC="1"
export PROTON_NO_FSYNC="1"
export SteamAppId="107410"
export SteamGameId="107410" 
export LD_PRELOAD="$HOME/.local/share/Steam/ubuntu12_64/gameoverlayrenderer.so"

# Help
if [[ $1 == "help" ]]; then
	echo "SCRIPT USAGE"
	echo
	echo "Dont forget to adjust settings by editing the script file!!"
	echo
	echo "Start TS: ./Arma3TS.sh"
	echo 
	echo "Install TS: ./Arma3TS.sh install [installer exe path]"
	echo
	echo "Help: ./Arma3TS.sh help"
	echo
	echo "Debug Information: ./Arma3TS.sh debug"
fi

# Executable paths
if [[ $USE_OWN_PROTONVERSION == true ]]; then
	PROTONEXEC="$HOME/.local/share/Steam/compatibilitytools.d/$PROTONVERSION/proton"
else
	PROTONEXEC="$HOME/.local/share/Steam/steamapps/common/Proton\ $PROTON_OFFICIAL_VER/proton"
fi
TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program\ Files/TeamSpeak\ 3\ Client/ts3client_win64.exe"

# Installer
if [[ $1 == "install" ]]; then
	echo "Trying to install Teamspeak with provided file"
	echo "INSTALL TEAMSPEAK FOR ALL USERS AND LEAVE THE PATH DEFAULT!!!"
	if [[ -z $2 ]]; then
		echo "Error - no installer exe provided"
	else
		sh -c "$PROTONEXEC run $2"
	fi
fi

# The command
if [[ -z $@ ]]; then
	sh -c "$PROTONEXEC run $TSPATH"
fi

# Print debug information
if [[ $1 = "debug" ]]; then
	echo "DEBUGGING INFORMATION"
	echo "Command Line:"
	echo "sh -c \"$PROTONEXEC run $TSPATH\""
	echo 
	if [[ $USE_OWN_PROTONVERSION == true ]]; then
		echo "Proton: official $PROTON_OFFICIAL_VER"
	else
		echo "Proton: custon $PROTON_CUSTOM_VERSION"
	fi
	echo 
	echo "Enviromentals:"
	if [[ -n $STEAM_COMPAT_DATA_PATH ]]; then
		echo "Enviromentals were successfully set ($PROTON_NO_FSYNC)"
		echo
		echo "STEAM_COMPAT_DATA_PATH: $STEAM_COMPAT_DATA_PATH"
		echo "SteamAppId/SteamGameId: $SteamAppId $SteamGameId"
		echo "LD_PRELOAD: $LD_PRELOAD"
		echo "PROTON_NO_ESYNC/PROTON_NO_FSYNC: $PROTON_NO_ESYNC/$PROTON_NO_FSYNC"
	else 
		echo "Enviromentals failed"
	fi
fi
## EOF
