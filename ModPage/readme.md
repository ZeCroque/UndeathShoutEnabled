# Undeath - Shouts and Hotkeys Enabled

## Index:

1. Overview
2. Details
3. Requirements
4. Known Issues
5. Mod content
6. Installation
7. Compatibility
8. My other mods
9. Credits
10. Tools used
11. Licensing/Legal 
12. Feedback

## 1. OVERVIEW

Adds shouting and hotkeys support for the lich transformation from the Undeath Classical Lichdom mod.

## 2. DETAILS

**THE AUTOMATIC INSTALL WON'T WORK AS IT, PLEASE READ CAREFULLY BEFORE REPORTING BUGS**

The mod has infortunately to ensure there's a keyboard binding for the left attack action. As it's probably not the case on your setup, you will need to make sure you have no "ControlMap_Custom.txt" file in Skyrim's root directory (where the *.exe* is) when you first install the mod. Deleting it will of course reset your custom keybinds, but you can set them back right after launching the game. **DO NOT CHANGE THE LEFT ATTACK ACTION THAT IS BOUND TO "???".**  

### Shouting

Shouting wasn't possible because there's no animations and behaviour for the dragon priest skeleton. I don't have the required skills to implement that but I found a quick workaround: using an "helper spell" as a proxy for the shout. When you hit the shout button, the mod auto-equips in your left hand that helper spell and then autocasts it, thus casting the shout. 

**Important notes:**
- The timing differs a bit from vanilla shouting.
- If you don't release the key, you'll hear the first word being shouted alone. The rest of the shout will be spoken once you stop holding. It means, as opposed to vanilla, you can charge your shouts (if that's of any interest to you).
- The shout will be directed where your crosshair was when you started shouting, not where it is when you release it. 

### Keybinds

Not much to say, it just works™. As stated below, the mod is incompatible with the [Extended Hotkey System by Vermunds](https://www.nexusmods.com/skyrimspecialedition/mods/32225).

## 3. REQUIREMENTS

- [SKSE64](https://www.nexusmods.com/skyrimspecialedition/mods/30379)
- [Undeath Remastered](https://www.nexusmods.com/skyrimspecialedition/mods/6180)
- [Undeath - Classical Lichdom v4](https://www.nexusmods.com/skyrimspecialedition/mods/40802)

## 4. KNOWN ISSUES

If you start casting a spell right after triggering a shout, the "helper spell" can stay in your hand. Cast it and everything will be back to normal.

The "Whirlwind Speed" shout is not supported because it uses a custom animation the lich skeleton lacks.

The thunder FX from "Unrelenting Force" does not play.

## 5. MOD CONTENT

This mod consists of two main files : 
- *UndeathShoutEnabled.esp* (small master)
- *UndeathShoutEnabled.bsa*

## 6. INSTALLATION

**Automatic (Recommended)**
- Use the Mod Manager Download button. Install and enable the file(s) in your favorite mod manager (ModOrganizer2 is my personal preference).

**Manual**
- Extract the required files (cf. `5. MOD CONTENT`) from the archive to your Data folder and activate them in the in-game Creations menu.

## 7. COMPATIBILITY

Incompatible with the [Extended Hotkey System by Vermunds](https://www.nexusmods.com/skyrimspecialedition/mods/32225)

## 8. MY OTHER MODS

- [Undeath - Alternate Lichdom Paths](https://www.nexusmods.com/skyrimspecialedition/mods/197102)
- [Soul Cairn Patches](https://www.nexusmods.com/skyrimspecialedition/mods/197103)
- [Prelude To Purgatory - Tweaks](https://www.nexusmods.com/skyrimspecialedition/mods/197104)

## 9. CREDITS

- Thanks to Bethesda Softworks for this great game
- Thanks to the authors of the patched mods
- Thanks to the authors of the tools listed below
- Thanks to xtcrefugee for answering my questions about mid/small masters on the Starfield Modding Discord
- Thanks to Revakyol for their [Shouts as Lesser Powers](https://www.nexusmods.com/skyrimspecialedition/mods/96599) mod, that gave me the idea for this mod
- Thanks RealAntithesis for their [AH Hotkeys - Skyrim Hotkey Manager SSE](https://www.nexusmods.com/skyrimspecialedition/mods/15761) mod, that shown me how to implement an auto-cast feature
- Thanks to DamEngineers for their [controlmap.txt - steamv1.6.1130](https://www.nexusmods.com/skyrimspecialedition/mods/106275) template

## 10. TOOLS USED

- Creation Kit
- xEdit
- Visual Studio Code
- Bethesda Archive Extractor
- Champollion
- Gimp & Photopea
- Copier
- Copilot (helped me create the data for the shout sounds)

## 11. LICENSING/LEGAL

If you want to modify and/or redistribute this mod, I would like to be contacted first please. Note that it is under GPL3 licensing, thus you have the obligation to make any modification done to the original source code available somewhere publicly.

You can find the source code [here](https://github.com/ZeCroque/UndeathShoutEnabled).

## 12. FEEDBACK

*Found a bug or have an idea for new features? Let me know in the comment section!*