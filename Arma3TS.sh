#!/usr/bin/env bash

# Licensed under GNU GPL 2.0 by Ingo "ninelore" Reitz <ninelore@protonmail.com>
# 
# Contributing:	famfo (famfo#0227)
# Testing:		G4rrus#3755 
# 
# Version 1v17-1
_SCRIPTVER="1v17-1"

###########################################################################
## Adjust below!
###########################################################################

## Path to Arma's compatdata (wineprefix)
# Leave default if Arma was installed in Steams default directory
COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata/107410"

## MAKE SURE THIS IS THE SAME AS THE PROTON VERSION OF ARMA IN STEAM!!!
# Set this to the Proton Version you are using with Arma!
# Available versions:
# Proton Experimental, 6.3, 5.13, 5.0, 4.11, 4.2, 3.16, 3.7
PROTON_OFFICIAL_VERSION="6.3"

# Set to true if you have proton installed in a seperate steam library
USE_DIFFERENT_STEAM_LIBRARY=false
# Path to steam library (steamapps folder)
STEAM_LIBRARY_PATH=""

# Set to true if you want to use custom proton in the compatibilitytoold.d folder
USE_OWN_PROTONVERSION=false
# Proton version (folder name in compatibilitytools.d)
PROTON_CUSTOM_VERSION=""

## Esync/Fsync
# WARNING: Make sure that both Arma and Teamspeak either use or dont use Esync and/or Fsync!!!
ESYNC=true
FSYNC=true

###########################################################################
## DO NOT EDIT BELOW!
###########################################################################

# Enviromentals
export STEAM_COMPAT_DATA_PATH="$COMPAT_DATA_PATH"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
export SteamAppId="107410"
export SteamGameId="107410"
if [[ $ESYNC == false ]]; then
	export PROTON_NO_ESYNC="1"
fi
if [[ $FSYNC == false ]]; then
	export PROTON_NO_FSYNC="1"
fi

if [[ $PROTON_OFFICIAL_VERSION == "Proton Experimental" ]]; then
	PROTON_OFFICIAL_VERSION="-\ Experimental"
fi

TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program\ Files/TeamSpeak\ 3\ Client/ts3client_win64.exe"
#export LD_PRELOAD="$HOME/.local/share/Steam/ubuntu12_64/gameoverlayrenderer.so" ## deprecated and subject of removal

# Executable paths
if [[ $USE_OWN_PROTONVERSION == true ]]; then
	PROTONEXEC="$HOME/.steam/steam/compatibilitytools.d/$PROTON_CUSTOM_VERSION/proton"
else
	if [[ $USE_DIFFERENT_STEAM_LIBRARY == true ]]; then
		PROTONEXEC="$STEAM_LIBRARY_PATH/common/Proton\ $PROTON_OFFICIAL_VERSION/proton"
	else
		PROTONEXEC="$HOME/.steam/steam/steamapps/common/Proton\ $PROTON_OFFICIAL_VERSION/proton"
	fi
fi

# Start
if [[ -z $@ ]]; then
	echo -e "\e[31mDon't forget to adjust the settings in the script!\e[0m \n"
	echo
	sh -c "$PROTONEXEC run $TSPATH"
# TS installer
elif [[ $1 == "install" ]]; then 
	echo "Trying to install Teamspeak with provided file"
	echo "INSTALL TEAMSPEAK FOR ALL USERS AND LEAVE THE PATH DEFAULT!!!"
	sleep 2
	if [[ -z $2 ]]; then
		echo "Error - no installer exe provided"
	else
		sh -c "$PROTONEXEC run $2"
	fi
# Debug information
elif [[ $1 = "debug" ]]; then
	echo "DEBUGGING INFORMATION"
	echo
	echo "Script Version: $_SCRIPTVER"
	echo
	echo "Command Line:"
	echo "sh -c \"$PROTONEXEC run $TSPATH\""
	echo
	if [[ $USE_OWN_PROTONVERSION == true ]]; then
		echo "Proton: custom $PROTON_CUSTOM_VERSION"
	else
		echo "Proton: official $PROTON_OFFICIAL_VERSION"
	fi
	echo
	if [[ -n $STEAM_COMPAT_DATA_PATH ]]; then
		echo "Enviromentals were successfully set"
		echo
		echo "STEAM_COMPAT_DATA_PATH: $STEAM_COMPAT_DATA_PATH"
		echo "SteamAppId/SteamGameId: $SteamAppId $SteamGameId"
		echo "ESync: $ESYNC"
		echo "FSync: $FSYNC"
	else
		echo "Enviromentals failed"
	fi
# Winetricks wrapper for Arma's compatdata
elif [[ $1 = "winetricks" ]]; then
	echo "Executing winetricks inside Arma's compatdata prefix..."
	export WINEPREFIX="$COMPAT_DATA_PATH/pfx"
	if [[ $2 = "Arma" ]]; then
		echo "Installing recommended features/DLLs for Arma"
		winetricks d3dcompiler_43 d3dx10_43 d3dx11_43 mfc140 xact_x64
	else
		echo "Winetricks Arguments: ${@:2}"
		winetricks ${@:2}
	fi
# Print usage if argument are invalid
else
	echo "SCRIPT USAGE"
	echo
	echo -e "\e[31mDont forget to adjust settings by editing the script file!\e[0m"
	echo -e "\e[31mEspecially check that Esync and Fsync match with Arma!\e[0m"
	echo -e "\e[31mAlso check that you use the right Proton version!\e[0m"
	echo
	echo "./Arma3TS.sh										- start Teamspeak"
	echo
	echo "./Arma3TS.sh install [installer exe path]			- install Teamspeak"
	echo
	echo "./Arma3TS.sh winetricks [winetricks arguments]	- Run a winetricks command inside the Arma prefix"
	echo
	echo "./Arma3TS.sh winetricks Arma						- Install recommended Features/DLLs for Arma via winetricks [As per Guide Chapter 5.1]"
	echo
	echo "./Arma3TS.sh debug								- Print Debugging Information"
fi

## End of File
