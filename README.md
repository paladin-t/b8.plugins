## Plugins for [BASIC8](https://paladin-t.github.io/b8/)

It's designed to contain the most commonly used features as built-in editors in BASIC8. I've also been getting questions like, "hi, can you make an importer/exporter for this or that format?" One of the reasons I created this repository is implementing some mechanism to simply and handily make operations BASIC8 doesn't offer. Obviously the title tells that "plugin" is that mechanism.

This repository contains plugins for paintable assets that I consider being between "generic" and "specific". It covers frequently asked requirements; and describes necessary information for developing your own plugins.

## Contents

You can pick anything you need here, and ignore others. But some of the plugin scripts require modules in `common` as dependency, so it's necessary to keep that directory, it's also recommended to put your own reusable modules inside it.

* [`common`](common): common modules, imported by code in other directories
	* [`utils.bas`](common/utils.bas)
	* [`frame.bas`](common/frame.bas)
	* [`sheet.bas`](common/sheet.bas)
* [`utilities`](utilities): just as its name implies
	* [`pick color.bas`](utilities/pick%20color.bas)
	* [`replace color.bas`](utilities/replace%20color.bas)
* [`working area`](working%20area): manipulates pixels for sprite, map, tiles, quantized, etc.
	* [`rotate clockwise.bas`](working%20area/rotate%20clockwise.bas)
	* [`rotate anticlockwise.bas`](working%20area/rotate%20anticlockwise.bas)
	* [`flip horizontally.bas`](working%20area/flip%20horizontally.bas)
	* [`flip vertically.bas`](working%20area/flip%20vertically.bas)
	* [`shift left.bas`](working%20area/shift%20left.bas)
	* [`shift right.bas`](working%20area/shift%20right.bas)
	* [`shift up.bas`](working%20area/shift%20up.bas)
	* [`shift down.bas`](working%20area/shift%20down.bas)
* [`frames`](frames): operations across frames
	* [`copy to all.bas`](frames/copy%20to%20all.bas)
* [`external formats`](external%20formats): importers and exporters
	* [`import sequence.bas`](external%20formats/import%20sequence.bas)
	* [`import 4x4 sheet.bas`](external%20formats/import%204x4%20sheet.bas)
	* [`import 3x4 sheet.bas`](external%20formats/import%203x4%20sheet.bas)
	* [`import tilesheet.bas`](external%20formats/import%20tilesheet.bas)
	* [`import frame.bas`](external%20formats/import%20frame.bas)
	* [`export frame.bas`](external%20formats/export%20frame.bas)
	* [`export frames.bas`](external%20formats/export%20frames.bas)

## How to use

### Installing

It's not recommended to manipulate regular disks under the library directory manually, but don't be afraid of screwing off to plug these expansions:

1. Clone or [download](https://github.com/paladin-t/b8.plugins/archive/master.zip) and extract the latest content somewhere on your computer
2. Create a `plugins` directory under the root directory of your disk library, if it's not yet been there, BASIC8 looks for plugins under that directory strictly
3. Put plugin scripts you just extracted under the `plugins` directory, do not include the `.git` stuff if you were cloning from here
4. You need to reopen BASIC8 to use any new plugged expansions

Some plugins require dependency modules by the `IMPORT` statement, plugin uses the following directory, for example, as lookup root to import another source file:

* "C:/Users/YourName/Documents/BASIC8/plugins/" on Windows
* "/Users/YourName/Documents/BASIC8/plugins/" on MacOS
* "/home/YourName/Documents/BASIC8/plugins/" on Linux

It's important to have the directory structure remain unchanged according to this repository under your local `plugins` directory. Files should be located at, for example:

* "C:/Users/YourName/Documents/BASIC8/plugins/[`common`](common)/[`frame.bas`](common/frame.bas)"
* "C:/Users/YourName/Documents/BASIC8/plugins/[`working area`](working%20area)/[`rotate clockwise.bas`](working%20area/rotate%20clockwise.bas)"
* Etc.

### Running

![](imgs/items.png)

Right click on the editing area of any paintable asset to show all plugged expansions which are usable for current context. Left click on a menu item to run it.

### Interrupting

Unlike regular disks, plugins run in the same thread with the graphics part. So as a plugin developer, you were in charge of guaranteeing a plugin runs and terminates normally. Press the Pause/Break key to interrupt the execution whenever you consider something is going wrong in plugin; click the close button on the BASIC8 window or Alt+F4 for the same affect, it breaks out even from unexpected infinite loop.

## Development

Only a subset of the BASIC8 programming libraries are exposed for plugin, including `Bytes`, `File`, `Image`, `IO`, `JSON`, `Math`, `System`, `Text` and `Utils`; besides, there are also some dedicated plugin only functions.

BASIC8 scans and plugs all plugins on startup by running it top down, reopen it for any new plugin; it also executes top down when triggering a plugin, but you don't need to reopen BASIC8 for changes in existing plugin, because each triggering is a new read-evaluate-process loop; and the plugin interpreter doesn't reserve values of variables. These two phases are called "plug" and "run" respectively.

### Meta

* `GET_PHASE()`: gets the current execution phase
	* returns either "plug" or "run"
* `REGISTER_PLUGIN(target, name, tips = NIL, sel = FALSE, squ = FALSE, cat = 100, pri = 10)`: registers a plugin
	* `target`: asset types to operate on, can be one or more in "sprite", "map", "tiles", "quantized", separated by comma, eg. "sprite, quantized"
	* `name`: plugin name
	* `tips`: tooltips
	* `sel`: whether plugin is available for selection only
	* `squ`: whether plugin is available for square area only
	* `cat`: category to group plugins in the context menu
	* `pri`: priority to sort plugins in the same category

A plugin script should contains zero (for common module) or one (for functional plugin) entry function called `REGISTER_PLUGIN`, generally you only need to call it during the "plug" phase. The `sel`, `squ` parameters are orthogonal in the `REGISTER_PLUGIN` function.

### Disk and assets

* `GET_DISK_CONTAINER_DIRECTORY()`: gets the path of container directory of the current disk
	* returns directory path
* `GET_DISK_CONTENT_DIRECTORY()`: gets the path of content directory of the current disk
	* returns directory path

* `GET_ASSET_FILE()`: gets the file path of the current asset
	* returns file path
* `SET_ASSET_UNSAVED()`: sets the current asset as unsaved

### Working area

Sprite frame, map layer and quantized image are all conceptualized as "frame" for plugins. The index of sprite starts from 1.

* `GET_FRAME_COUNT()`: gets the count of frames in the current asset
	* returns integer
* `GET_FRAME_RANGE()`: gets the appointed range in the current asset, only works with sprite by the indicator below
	* returns vec2 of begin, end frame indices

![](imgs/range.png)

* `GET_FRAME_SIZE()`: gets the size in pixels of a pixeled frame, or tile count of a map
	* returns vec2 of width, height
* `GET_FRAME_INDEX()`: gets the active frame index of the current asset
	* returns integer
* `SET_FRAME_INDEX(i)`: sets the active frame index of the current asset
	* `i`: target index

* `HAS_SELECTION()`: checks whether any area is selected by the lasso tool
	* returns true for area selected
* `GET_SELECTION_RANGE()`: gets the selected area
	* returns vec4 of left, top, right, bottom, or nil for none selection

* `GET_CURSOR_POSITION()`: gets the position of the cursor
	* returns vec2 of x, y, or nil for not available

* `GET_PIXEL(x, y)`: gets the data at a specific position
	* `x`: x position
	* `y`: y position
	* returns palette index for pixeled, or tile index for map
* `SET_PIXEL(x, y, p)`: sets the data at a specific position with given data
	* `x`: x position
	* `y`: y position
	* `p`: palette or tile index as integer

### Operation

* `PUSH_OPERATION(op [, i])`: pushes an operation, as if operated manually by a user on editors
	* `op`: operation type, only "add" available for now, for adding frame or layer to sprite, map assets
	* `i`: destination index to perform adding, or append to tail when not specified
* `BEGIN_OPERATION([msg])`: begins a plugin operation
	* `msg`: text message to be displayed on the undo/redo tooltip
* `END_OPERATION()`: ends a plugin operation

All pixel modifications by the `SET_PIXEL` function are packed between a pair of `BEGIN_OPERATION` and `END_OPERATION`, as a single undo/redo step.

### Source

* `GET_SOURCE_INDEX()`: gets the selected palette color, tile index, etc.
	* returns integer
* `SET_SOURCE_INDEX(src)`: sets the selected palette color, tile index, etc.
	* `src`: integer

* `GET_PALETTE_FROM_COLOR(c)`: gets the palette index represents for the nearest color with specific color
	* `c`: color to match
	* returns palette index
* `GET_COLOR_FROM_PALETTE(p)`: gets the RGBA value from specific palette index
	* returns RGBA value

### File dialog

* `OPEN_FILE_DIALOG([y, m = FALSE])`: shows a dialog box to open file
	* `y`: file type extensions, separated by comma
	* `m`: true for allowing multiple selection
	* returns file path for single selection, list of file paths for multiple selection, or nil for canceled
* `SAVE_FILE_DIALOG([y])`: shows a dialog box to save file
	* `y`: file type extensions, separated by comma
	* returns file path, or nil for canceled
* `PICK_DIRECTORY_DIALOG([d])`: shows a dialog to pick directory
	* `d`: default directory
	* returns dialog path, or nil for canceled
