[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/evil-morfar/RCLootCouncil_Classic?include_prereleases)](https://www.curseforge.com/wow/addons/rclootcouncil-classic)
[![Discord](https://img.shields.io/discord/427445230870986752?color=%237289DA&label=Discord)](http://discord.rclootcouncil.com)
[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://patreon.com/rclootcouncil)

# RCLootCouncil Classic
World of Warcraft Classic port of [RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil).

Latest release is available at [Curse](https://www.curseforge.com/wow/addons/rclootcouncil-classic/), [Wago](https://addons.wago.io/addons/rclootcouncil-classic), or [GitHub](https://github.com/evil-morfar/RCLootCouncil_Classic/releases).

The [RCLootCouncil Wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki) is also the official documentation source of features, although a few things have been removed from this version.

## Description

> Note: *Each game version has a seperate file for download*.

This project is an direct extension to RCLootCouncil, so that it may be updated without any changes to the core project. Instead patches, hooks, and replacements are implemented to modify the core addon to function within the Classic environment.

This also allows for future updates of RCLootCouncil to be easily implemented, as it's mostly core features that need changing for Classic.

Refer to main addon for feature details. For general support, head on over to the [discord](http://discord.rclootcouncil.com).


## Git Flow

RCLootCouncil Classic is developed using the [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) branching model.

## Developers

For those interested, RCLootCouncil Classic contains several development scripts located in the *.scripts* folder. Most of these relies on a **.env** file being present in the root folder, which can contain the following fields:
* **WOW_LOCATION="wow_path"**  
WoW install location - used in the *deploy* script to copy the development files into the WoW AddOns folder.

* **CF_API_KEY="key"**  
CurseForge API key. Used by the *release* script to upload new files. You probably don't need this.

* **GITHUB_OAUTH="key"**  
GitHub OAUTH key. Used by the *release* script to manage GitHub releases. You probably don't need this.

### Build process

RCLootCouncil uses slightly modified version of [BigWigsMods release.sh](https://github.com/BigWigsMods/packager) which allows it to run on Git submodules, and more importantly, fetch the localization files for the retail version of RCLootCouncil bundled into the addon. See *build.sh* for details.

#### Dependencies

git, bash and sed.
