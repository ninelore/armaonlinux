# Arma on Linux - Guide by 9L



## Preamble:

I'm ninelore, also known under my name Ingo. After I did a lot of tinkering with Linux in my life, i became a full-time Linux user after the announcement of Steam Proton.

Some months and Proton improvements later i had the first known, good working Arma Installation on Linux.

Since Proton 4.11 as good as all tweaks needed to run Arma became obsolete, and it became as easy as never before to play not only Arma and Steam Games, but also non-Steam games because of many Proton improvements being up streamed     to Wine. You can check if your Games are working on the Lutris Website, the WineHQ and the ProtonDB Websites.

This new Guide is based on all the knowledge that got collected up until now. This Guide will get continuous Updates

## 0. Disclaimer

**I don't take any responsibility if any (im)possible damage occurs on your hardware, software or your health, if you lose your job because you were late because your alarm clock didn't ring or if a thermonuclear war breaks out. You     are responsible for all changes you are making! Please read everything carefully and if needed twice to prevent Misunderstandings. You can contact me via the Information provided in my [Github Profile](https://github.com/ninelore)**

## 1. Prepare

You should have
- Basic Terminal/Bash knowledge
- All Software and Drivers updated
- Already installed Steam and wine-staging to make sure all dependencies are installed

## 2. Downloading Arma

Do the following before starting to download Arma!

Go into Steam settings and then click on "Steam Play". Check both boxes and choose the newest Proton version available (not Experimental)
![Steam Play Settings](guide-images/steamplaysettings.png)

Now go into the Steam game settings menu and add the `%command% -nolauncher` to the launch options
![Arma Launch Options in Steam](guide-images/armalaunchoptions.png)

Then go into the "Compatibility" Tab and set the Proton Version again
![Arma Proton version](guide-images/armaprotonversion.png)

Now you can start the downlaod of Arma 3.  

## 3. Starting and playing the Game

When the download is finished, start the game once and exit it again after reaching the main menu.

Now you need a Launcher to manage Mods and launch options. I highly recommend using the [Arma 3 Unix Launcher by muttleyxd](https://github.com/muttleyxd/arma3-unix-launcher).  
Download: [Arch Linux AUR](https://aur.archlinux.org/packages/arma3-unix-launcher-bin) | [as .deb or .AppImage](https://github.com/muttleyxd/arma3-unix-launcher/releases/latest)

This is everything you need to play Arma 3 on Linux without ACRE2 or TFAR. Congratulations to get this far. ;)

## 4. ACRE2/TFAR

Make sure you did the command of Point 5.1!

Untar the Proton build provided in this repository and place the folder in `$HOME/.local/share/Steam/compatibilitytools.d/` (create the directory if absent).  
Restart Steam(!) and go into the Steam game settings of Arma again and change the Proton version the the one we just installed (see the 3rd picture in 2.).

Place the `Arma3TS-*.sh` in your home directory.  
Edit the file and adjust the settings inside the marked area in that file according to the comments.  
Now download a recent **Windows Installer(!)** of Teamspeak 3.  
Install Teamspeak into the compatdata directory of Arma by running `./Arma3TS-*.sh install path/to/TS3-Installer.exe`.  
**IMPORTANT: In the Teamspeak Installer, select "Install for all Users" and leave the default path!!!**

After the Insallation you can start TeamSpeak by just running `./Arma3TS-*.sh` **After you have started Arma**.

Done!

## 5. Troubleshooting

#### 5.1 I have problems with sound and/or thermal vision  
Install [protontricks via python pipx](https://github.com/Matoking/protontricks#pipx-recommended) and run the following command:  
`protontricks 107410 d3dcompiler_43 d3dx10_43 d3dx11_43 mfc140 xact_64`

#### 5.2 Arma doesnt open or crashes instantly
Run the following command depending on your linux distro to install possibly missing dependencies  
Arch Linux based: `sudo pacman -S vulkan-tools`  
Debian/Ubuntu based: `sudo apt install mesa-vulkan-drivers vulkan-utils`  
Fedora: `sudo dnf install mesa-vulkan-drivers vulkan-tools`

#### 5.3 Comman X returns error Y
Double Check for Software and Driver Updates aswell as the spelling of the Commands and the Settings. If you still got errors continue to 5.99

#### 5.99 More help is available on the [ArmaOnUnix Discord](https://discord.gg/p28Ra36)

## Epilogue

This Guide was first released in the [Armaworld Forums]() by me. If you have Feedback or Questions dont hesitate to open a Issue.
