#!/usr/bin/env bash

# Licensed under GNU GPL 2.0 4.0 by Ingo "ninelore" Reitz <ninelore@protonmail.com>
# Thanks to: G4rrus#3755 (testing) ; famfo#0227 (testing)

# Version 1v14-2

###########################################################################
## Adjust below!
###########################################################################

## Path to Arma's compatdata (wineprefix)
# Leave default if Arma was installed in Steams default directory
COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata/107410"

## MAKE SURE THIS IS THE SAME AS THE PROTON VERSION OF ARMA IN STEAM!!!
# Set this to the Proton Version you are using with Arma!
PROTON_OFFICIAL_VERSION="6.3"

# Set to true if you have proton installed in a seperate steam library
USE_DIFFERENT_STEAM_LIBRARY=true
# Path to steam library
STEAM_LIBRARY_PATH="/mnt/2TB_HDD/Launcher/Steam/steamapps/common"

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

#export LD_PRELOAD="$HOME/.local/share/Steam/ubuntu12_64/gameoverlayrenderer.so"

# Help
if [[ $1 == "help" ]]; then
	echo "SCRIPT USAGE"
	echo
	echo "Dont forget to adjust settings by editing the script file!!"
        echo -e "\e[31mBe shure to check ESync and FSync both in Arma and the script!\e[0m"
        echo "Make shure that Arma and this script are using the same Proton version."
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
	PROTONEXEC="/mnt/2TB_HDD/Launcher/Steam/steamapps/common/Proton\ 6.3/proton"
    else
        if [[ $USE_DIFFERENT_STEAM_LIBRARY == true ]]; then
	    PROTONEXEC="$STEAM_LIBRARY_PATH/Proton\ $PROTON_OFFICIAL_VERSION/proton"
        else
	    PROTONEXEC="$HOME/.local/share/Steam/steamapps/common/Proton\ $PROTON_OFFICIAL_VERSION/proton"
    fi
fi

TSPATH="$COMPAT_DATA_PATH/pfx/drive_c/Program\ Files/TeamSpeak\ 3\ Client/ts3client_win64.exe"

# Installer
if [[ $1 == "install" ]]; then
	echo "Trying to install Teamspeak with provided file"
	echo "INSTALL TEAMSPEAK FOR ALL USERS AND LEAVE THE PATH DEFAULT!!!"
	sleep 2
	if [[ -z $2 ]]; then
		echo "Error - no installer exe provided"
	else
		sh -c "$PROTONEXEC run $2"
	fi
fi

# The command
if [[ -z $@ ]]; then
        echo -e "\e[31mDon't forget to adjust the settings in the script!\e[0m \n"
        echo "Esync: $ESYNC"
        echo "Fsync: $FSYNC"
        echo
        sh -c "$PROTONEXEC run $TSPATH"
fi

# Print debug information
if [[ $1 = "debug" ]]; then
	echo "DEBUGGING INFORMATION"
	echo "Command Line:"
	echo "sh -c \"$PROTONEXEC run $TSPATH\""
	echo
	if [[ $USE_OWN_PROTONVERSION == true ]]; then
		echo "Proton: custom $PROTON_CUSTOM_VERSION"
	else
		echo "Proton: official Protn $PROTON_OFFICIAL_VERSION"
	fi
	echo
	if [[ -n $STEAM_COMPAT_DATA_PATH ]]; then
		echo "Enviromentals were successfully set"
		echo
		echo "STEAM_COMPAT_DATA_PATH: $STEAM_COMPAT_DATA_PATH"
		echo "SteamAppId/SteamGameId: $SteamAppId $SteamGameId"
		echo "LD_PRELOAD: $LD_PRELOAD"
		echo "ESync: $ESYNC"
                echo "FSync: $FSYNC"
	else
		echo "Enviromentals failed"
	fi
fi
## EOF
