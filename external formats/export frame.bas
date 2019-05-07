REM BASIC8
REM Copyright (C) 2017 - 2019 Tony Wang
REM Plugin program of BASIC8.

REM Imports common modules.

import "common/utils"

REM Loads the plugin.

def plug()
	print "Loading plugin: Export frame...";
	register_plugin
	(
		"sprite, quantized", ' Target assets.
		"Export frame", ' Name.
		"Export the selection or current frame to image", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		30, ' Category.
		60 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	' Prepares.
	print "Running plugin: Export frame...";
	x0 = 0
	y0 = 0
	x1 = 0
	y1 = 0
	w = 0
	h = 0
	' Gets the operating area.
	if has_selection() then
		v = get_selection_range()
		unpack(v, x0, y0, x1, y1)
	else
		v = get_frame_size()
		unpack(v, x1, y1)
		x1 = x1 - 1
		y1 = y1 - 1
	endif
	w = x1 - x0 + 1
	h = y1 - y0 + 1
	' Fills in the pixels at target image with the working area.
	g = image()
	g.resize(w, h)
	for j = 0 to h - 1
		y = y0 + j
		for i = 0 to w - 1
			x = x0 + i
			p = get_pixel(x, y)
			c = get_color_from_palette(p)
			g.set(i, j, c)
		next
	next
	' Saves to file.
	f = save_file_dialog("png,bmp,tga,jpg")
	if not f then
		return
	endif
	f = validate_image_file(f)
	g.save(f, right(f, 3))
enddef

REM Checks the operation.

ph = get_phase()
if ph = "plug" then
	plug()
elseif ph = "run" then
	run()
endif
