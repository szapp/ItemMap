# ItemMap

[![Scripts](https://github.com/szapp/ItemMap/actions/workflows/scripts.yml/badge.svg)](https://github.com/szapp/ItemMap/actions/workflows/scripts.yml)
[![Validation](https://github.com/szapp/ItemMap/actions/workflows/validation.yml/badge.svg)](https://github.com/szapp/ItemMap/actions/workflows/validation.yml)
[![Build](https://github.com/szapp/ItemMap/actions/workflows/build.yml/badge.svg)](https://github.com/szapp/ItemMap/actions/workflows/build.yml)
[![GitHub release](https://img.shields.io/github/v/release/szapp/ItemMap.svg)](https://github.com/szapp/ItemMap/releases/latest)  
[![World of Gothic](https://raw.githubusercontent.com/szapp/patch-template/main/.github/actions/initialization/badges/wog.svg)](https://www.worldofgothic.de/dl/download_634.htm)
[![Spine](https://raw.githubusercontent.com/szapp/patch-template/main/.github/actions/initialization/badges/spine.svg)](https://clockwork-origins.com/spine)
[![Steam Gothic 1](https://img.shields.io/badge/steam-Gothic%201-2a3f5a?logo=steam&labelColor=1b2838)](https://steamcommunity.com/sharedfiles/filedetails/?id=2787021109)
[![Steam Gothic 2](https://img.shields.io/badge/steam-Gothic%202-2a3f5a?logo=steam&labelColor=1b2838)](https://steamcommunity.com/sharedfiles/filedetails/?id=2787020561)

Mark all items (and non-empty chests) in the world on the map (Gothic, Gothic Sequel, Gothic 2, and Gothic 2 NotR).

This is a modular modification (a.k.a. patch or add-on) that can be installed and uninstalled at any time and is virtually compatible with any modification.
It supports <kbd>Gothic 1</kbd>, <kbd>Gothic Sequel</kbd>, <kbd>Gothic II (Classic)</kbd> and <kbd>Gothic II: NotR</kbd>.

<sup>Generated from [szapp/patch-template](https://github.com/szapp/patch-template).</sup>

## About

The patch draws all items that are currently in the world dynamically onto every map.
Non-looted chests are also displayed.

The various item categories are indicated by colors which are adjustable.
The visibility of the markers can be toggled to still allow to use the map without them.
Collected items will no longer be displayed on the map.

The patch takes into account any kind of item and can thus be used with any modification.

<div align="center">
<a href="https://github.com/szapp/ItemMap/assets/20203034/98a2c65f-fd23-4a63-b759-ebca06ed6219"><img src="https://github.com/szapp/ItemMap/assets/20203034/78ede39e-db1d-4b65-9229-c1ed47378c52" alt="Screenshot" width="45%" /></a> &nbsp;
<a href="https://github.com/szapp/ItemMap/assets/20203034/d2c4548e-5655-4b46-86ce-a59473fbf959"><img src="https://github.com/szapp/ItemMap/assets/20203034/1e1d52b3-1053-498d-80f6-de427dd9f413" alt="Screenshot" width="45%" /></a>
</div>

## Additional key bindings

<table>
  <tbody>
    <tr>
      <td>
        <kbd>Draw weapon</kbd>
      </td>
      <td>Toggle the visibility of the item markings</td>
    </tr>
  </tbody>
</table>

## INI settings

The visualization of the items can be adjusted in the Gothic.ini in the section `[ITEMMAP]`.
It will be automatically created on first launch.

- The colors of the individual item categories can be set by six-digit hexadecimal color values (pre-pended with a '#', e.g. `#00D358`).
- Individual item categories can be omitted completely by setting the color value to `0` or `FALSE`.
- With `minValue`, the minimum trading value can be set of displayed items.
This way, the amount of items can be reduced to the most interesting ones.
- With `radius`, only the items within a certain range (meters) of the player are shown.
With `-1` or `0` all items are shown.

## Notes

- For modifications with large amounts of items in the world, opening the map may take one or two seconds.
There, it is recommended to increase `minValue` in the Gothic.ini or the disable individual item categories (see above).
Under normal circumstances and world sizes (i.e. Gothic 2 Khorinis), there is no noticeable delay.

- An [example of suitable color settings](https://forum.worldofplayers.de/forum/threads/?p=26382147) is demonstrated in the German World of Gothic Forum.
There, only valuable (i.e. permanent bonuses) plants (green), potions (blue), and stone plates (yellowish) are shown.

- Items/containers are only displayed on maps that report the player position.

- The size of the markers follows the interface scaling (`[INTERFACE]` scale).

- The default settings of the color values look like this:
```ini
[ITEMMAP]
radius=-1
minValue=0
combat=#E23D28
armor=#FF7F00
rune=#FC00FC
magic=#FFFA00
food=#00D358
potion=#00BFFF
docs=#FCF3B5
other=#898989
chest=#7F512E
```

## Installation

1. Download the latest release of `ItemMap.vdf` from the [releases page](https://github.com/szapp/ItemMap/releases/latest).

2. Copy the file `ItemMap.vdf` to `[Gothic]\Data\`. To uninstall, remove the file again.

The patch is also available on
- [World of Gothic](https://www.worldofgothic.de/dl/download_634.htm) | [Forum thread](https://forum.worldofplayers.de/forum/threads/1554831)
- [Spine Mod-Manager](https://clockwork-origins.com/spine/)
- [Steam Workshop Gothic 1](https://steamcommunity.com/sharedfiles/filedetails/?id=2787021109)
- [Steam Workshop Gothic 2](https://steamcommunity.com/sharedfiles/filedetails/?id=2787020561)

### Requirements

<table><thead><tr><th>Gothic</th><th>Gothic Sequel</th><th>Gothic II (Classic)</th><th>Gothic II: NotR</th></tr></thead>
<tbody><tr><td><a href="https://www.worldofgothic.de/dl/download_34.htm">Version 1.08k_mod</a></td><td>Version 1.12f</td><td><a href="https://www.worldofgothic.de/dl/download_278.htm">Report version 1.30.0.0</a></td><td><a href="https://www.worldofgothic.de/dl/download_278.htm">Report version 2.6.0.0</a></td></tr></tbody>
<tbody><tr><td colspan="4" align="center"><a href="https://github.com/szapp/Ninja/wiki#wiki-content">Ninja 2.9.15</a> or higher</td></tr></tbody></table>

<!--

If you are interested in writing your own patch, please do not copy this patch!
Instead refer to the PATCH TEMPLATE to build a foundation that is customized to your needs!
The patch template can found at https://github.com/szapp/patch-template.

-->
