## Plugins for BASIC8

I've made many generic functionalities as native editors in BASIC8, and I've also been getting questions like, "hey, can you make an importer, exporter for ??? format?" One of the reasons I create this repository is to answer those questions. I would prefer to make feature being specific to a particular usage as scriptable plugin, instead of solid functionality. Since they are optional, and not always used developing every disk. Moreover, it feels great to have the editors extendable, rather than limited to what I've provided.

This repository contains plugins for paintable assets that I consider as something between "generic to all" and "specific to one", thus useful but not must have; and necessary information for developing your own plugins. Any pull requests are welcome!

## Contents

You can choose whatever you need, and ignore what you are not interested. But some of the plugin items requires modules in `common` as dependency, so it's recommended to keep that directory.

* [`common`](common): common modules, imported by code in other directories
	* [`utils`](common/utils.bas)
	* [`frame`](common/frame.bas)
	* [`sheet`](common/sheet.bas)
* [`utilities`](utilities): utilities
	* [`pick color`](utilities/pick color.bas)
* [`working area`](working area): manipulates pixels for sprite, map, tiles, quantized, etc.
	* [`rotate clockwise`](working area/rotate clockwise.bas)
	* [`rotate anticlockwise`](working area/rotate anticlockwise.bas)
	* [`flip horizontally`](working area/flip horizontally.bas)
	* [`flip vertically`](working area/flip vertically.bas)
* [`external formats`](external formats): importers and exporters
	* [`import sequence`](external formats/import sequence.bas)
	* [`import 4x4 sheet`](external formats/import 4x4 sheet.bas)
	* [`import 4x3 sheet`](external formats/import 4x3 sheet.bas)
	* [`export frame`](external formats/export frame.bas)
	* [`export frames`](external formats/export frames.bas)

## Using

### Installation

It's not recommended to manipulate disks under the library directory manually, but don't be afraid of screwing off to install these plugins, following steps:

1. Clone or download then extract the latest [content](https://github.com/paladin-t/b8.plugins/archive/master.zip) to your local storage
2. Create a `plugins` directory under the root directory of your disk library if it's not yet there
3. Put extracted plugins under the `plugins` directory
4. You need to reopen BASIC8 to use any new added plugin

Some plugins requires common modules by the `IMPORT` statement, BASIC8 uses the following directory, for example, as lookup root to import another source file:

* "C:/Users/YourName/Documents/BASIC8/plugins/" on Windows
* "/Users/YourName/Documents/BASIC8/plugins/" on MacOS
* "/home/YourName/Documents/BASIC8/plugins/" on Linux

Keep the directory structure of this repository under your local `plugins` directory, files should be put at, for example:

* "C:/Users/YourName/Documents/BASIC8/plugins/[`common`](common)/[`frame.bas`](common/frame.bas)"
* "C:/Users/YourName/Documents/BASIC8/plugins/[`working area`](working area)/[`rotate clockwise.bas`](working area/rotate clockwise.bas)"
* Etc.

### Running

![](imgs/items.png)

Right click on the editing area of any paintable asset to show all plugged items. Left click on an item to trigger it.

### Interrupting

Unlike regular disks, plugins run in the same thread with the graphics shell. So you were in charge of ensuring a plugin runs and terminates normally, as a plugin developer. Besides, press the Pause/Break key to interrupt the execution whenever developing or using a plugin; click the close button on the BASIC8 window or Alt+F4 for the same affect, even from an unexpected infinity loop.

## Development

Only a subset of the full BASIC8 libraries is exposed to plugin, including `Bytes`, `File`, `Image`, `IO`, `JSON`, `Math`, `System`, `Text` and `Utils`; besides, there are also some dedicated functions exposed for plugin only.

BASIC8 parses and plugs all plugins at startup, reopen it for any new created plugin; it executes top down each time when triggering a plugin, you don't need to reopen BASIC8 when developing a plugin's logic iteratively. These two phases are respectively called "plug" and "run".

### Meta

* `GET_PHASE()`: gets current execution phase
	* returns either "plug" or "run"
* `REGISTER_PLUGIN(target, name, tips = NIL, sel = FALSE, squ = FALSE, cat = 100, pri = 10)`: registers a plugin
	* `target`: asset types to operate on, can be one or more in "sprite", "map", "tiles", "quantized", separated by comma
	* `name`: plugin name
	* `tips`: tooltips
	* `sel`: whether plugin is strictly suitable for selection only
	* `squ`: whether plugin is strictly suitable for square area only
	* `cat`: category
	* `pri`: priority

Generally you only need to call the `REGISTER_PLUGIN` function during "plug" phase. In the `REGISTER_PLUGIN` function, the `sel`, `squ` parameters are orthogonality; final items will be sorted by `cat` primarily, then falls to `pri`.

### Disk and assets

* `GET_DISK_CONTAINER_DIRECTORY()`: gets the container directory path of the current disk
	* returns directory path
* `GET_DISK_CONTENT_DIRECTORY()`: gets the content directory path of the current disk
	* returns directory path

* `GET_ASSET_FILE()`: gets the file path of the current asset
	* returns file path
* `SET_ASSET_UNSAVED()`: sets the current asset to unsaved

### Working area

Sprite frame, map layer and quantized image are all conceptualized as "frame" with working area functions. Index of sprite starts from 1.

* `GET_FRAME_COUNT()`: gets the count of frames in the current asset
	* returns integer
* `GET_FRAME_RANGE()`: gets the active range in the current asset, only works with sprite by following indicator
	* returns vec2 for begin, end frame indices

![](imgs/range.png)

* `GET_FRAME_SIZE()`: gets the size in pixels or tiles of a frame
	* returns vec2 for width, height
* `GET_FRAME_INDEX()`: gets the selected frame index of the current asset
	* returns integer
* `SET_FRAME_INDEX(i)`: sets the selected frame index of the current asset
	* `i`: target index

* `HAS_SELECTION()`: checks whether any area is selected by the lasso tool
	* returns true if any area selected
* `GET_SELECTION_RANGE()`: gets the selected area
	* returns vec4 for left, top, right, bottom, or nil for none selection

* `GET_CURSOR_POSITION()`: gets the position of the cursor
	* returns vec2 for x, y, or nil for not available

* `GET_PIXEL(x, y)`: gets the data at a specific position
	* `x`: x position
	* `y`: y position
	* returns palette index, or tile index for map
* `SET_PIXEL(x, y, p)`: sets the data at a specific position with given data
	* `x`: x position
	* `y`: y position
	* `p`: integer data

### Operation

* `PUSH_OPERATION(op [, i])`: pushes an operation, as if operated manually on editors
	* `op`: operation type, only "add" available until now, for adding frame or layer to sprite, map assets
	* `i`: where to add before, or append after back if not passed
* `BEGIN_OPERATION([msg])`: begins a plugin operation
	* `msg`: text message to be displayed on the undo/redo tooltip
* `END_OPERATION()`: ends a plugin operation

All pixel modifications by the `SET_PIXEL` function are encapsulated between a pair of `BEGIN_OPERATION` and `END_OPERATION`, for undo/redo.

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

* `OPEN_FILE_DIALOG([y [, m]])`: shows an open file dialog box
	* `y`: file type extensions, separated by comma
	* `m`: true for multiple selection
	* returns file path for single selection, list of file paths for multiple selection, or nil for canceled
* `SAVE_FILE_DIALOG([y])`: shows a save file dialog box
	* `y`: file type extensions, separated by comma
	* returns file path, or nil for canceled
