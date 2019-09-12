REM BASIC8
REM Copyright (C) 2018 - 2019 Tony Wang
REM Plugin program of BASIC8.

REM Imports common modules.

import "common/sheet"

REM Loads the plugin.

def plug()
	print "Loading plugin: Import 3x4 sheet...";
	register_plugin
	(
		"sprite", ' Target assets.
		"Import 3x4 sheet", ' Name.
		"Import an image sheet to the current sprite asset", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		40, ' Category.
		30 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	print "Running plugin: Import 3x4 sheet...";
	f = open_file_dialog("png,bmp,tga,jpg")
	if not f then
		return
	endif
	import_sheet_file(f, 3, 4, true) ' Imports 3x4 sheet, stretches if necessary.
enddef

REM Checks the operation.

ph = get_phase()
if ph = "plug" then
	plug()
elseif ph = "run" then
	run()
endif
