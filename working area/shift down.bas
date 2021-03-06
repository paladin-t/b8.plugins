REM BASIC8
REM Copyright (C) 2018 - 2019 Tony Wang
REM Plugin program of BASIC8.

REM Imports common modules.

import "common/frame"

REM Loads the plugin.

def plug()
	print "Loading plugin: Shift down...";
	register_plugin
	(
		"sprite, map, tiles, quantized", ' Target assets.
		"Shift down", ' Name.
		nil, ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		20, ' Category.
		80 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	' Prepares.
	print "Running plugin: Shift down...";
	x0 = 0
	y0 = 0
	x1 = 0
	y1 = 0
	w = 0
	h = 0
	d = nil
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
	' Gets the current pixels.
	d = get_pixels_rect(x0, y0, w, h)
	' Sets with the new pixels.
	begin_operation("Shift down")
	for i = 0 to w - 1
		x = x0 + i
		for j = 0 to h - 1
			y = y0 + j
			oy = y0 + j - 1
			if oy < y0 then
				oy = y1
			endif
			k = hash_xy(x, oy, w)
			c = get(d, k)
			set_pixel(x, y, c)
		next
	next
	end_operation()
	' Marks the asset dirty.
	set_asset_unsaved()
enddef

REM Checks the operation.

ph = get_phase()
if ph = "plug" then
	plug()
elseif ph = "run" then
	run()
endif
