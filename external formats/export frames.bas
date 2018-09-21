REM BASIC8
REM Copyright (C) 2017 - 2018 Tony Wang
REM Plugin program of BASIC8.

REM Imports common modules.

import "common/utils"

REM Loads the plugin.

def plug()
	print "Loading plugin: Export frames...";
	register_plugin
	(
		"sprite", ' Target assets.
		"Export frames", ' Name.
		"Export the selected range to images", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		30, ' Category.
		70 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	' Prepares.
	print "Running plugin: Export frames...";
	b = 0
	e = 0
	w = 0
	h = 0
	' Saves the selected frame index.
	s = get_frame_index()
	' Gets the frame size.
	v = get_frame_size()
	unpack(v, w, h)
	' Gets the selected range.
	v = get_frame_range()
	unpack(v, b, e)
	if b < 1 then b = 1
	if b > get_frame_count() then b = get_frame_count()
	if e < 1 then e = 1
	if e > get_frame_count() then e = get_frame_count()
	' Fills in the pixels at target image with the working area.
	l = list()
	for i = b to e
		set_frame_index(i)
		g = image()
		g.resize(w, h)
		for y = 0 to h - 1
			for x = 0 to w - 1
				p = get_pixel(x, y)
				c = get_color_from_palette(p)
				g.set(x, y, c)
			next
		next
		push(l, g)
	next
	' Saves to file.
	f = save_file_dialog("png,bmp,tga,jpg")
	if not f then
		return
	endif
	f = validate_image_file(f)
	for i = 0 to len(l) - 1
		g = get(l, i)
		n = left(f, len(f) - 4) + str(i) + right(f, 4)
		g.save(n, right(f, 3))
	next
	' Restores the selected frame index.
	set_frame_index(s)
enddef

REM Checks the operation.

ph = get_phase()
if ph = "plug" then
	plug()
elseif ph = "run" then
	run()
endif
