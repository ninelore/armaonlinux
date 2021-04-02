#!/usr/bin/env bash

# Licensed under CC BY-SA 4.0 by Ingo "ninelore" Reitz <ninelore@protonmail.com>
# https://creativecommons.org/licenses/by-sa/4.0/ 
# Thanks to: G4rrus#3755 (testing)

# Version 1v12-1

###########################################################################
## Adjust below!
###########################################################################

# Path to Arma's compatdata (wineprefix)
# Leave default if Arma was installed in Steams default directory
COMPAT_DATA_PATH="$HOME/home2/SteamLibrary/steamapps/compatdata/107410"

## MAKE SURE THIS IS THE SAME AS THE PROTON VERSION OF ARMA IN STEAM!!!
# Set if you want to use a official Proton Version instead of a custom one
USE_PROTON_OFFICIAL=true
# If above is true, set this to either "4.11", "5.0" or "5.13"
PROTON_OFFICIAL_VER="5.13"

# Proton version (folder name in compatibilitytools.d)
PROTONVERSION="proton_tkg_6.2.r0.g3b5ea332.arma-9l"

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
	echo "Start TS with official Proton once: ./Arma3TS.sh official"
	echo 
	echo "Install TS: ./Arma3TS.sh install [installer exe path]"
	echo
	echo "Help: ./Arma3TS.sh help"
	echo
	echo "Debug Information: ./Arma3TS.sh debug"
fi

# Option for temporary official Proton
if [[ $1 == "official" ]]; then
	USE_PROTON_OFFICIAL=true
fi

# Executable paths
if [[ $USE_PROTON_OFFICIAL == true ]]; then
	PROTONEXEC="$HOME/.local/share/Steam/steamapps/common/Proton\ $PROTON_OFFICIAL_VER/proton"
else
	PROTONEXEC="$HOME/.local/share/Steam/compatibilitytools.d/$PROTONVERSION/proton"
fi
TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program\ Files/TeamSpeak\ 3\ Client/ts3client_win64.exe"

# install
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
