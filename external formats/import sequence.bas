REM BASIC8
REM Copyright (C) 2017 - 2018 Tony Wang
REM Plugin program of BASIC8.

REM Imports common modules.

import "common/frame"

REM Loads the plugin.

def plug()
	print "Loading plugin: Import sequence...";
	register_plugin
	(
		"sprite", ' Target assets.
		"Import sequence", ' Name.
		"Import a sequence of images to the current sprite asset", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		30, ' Category.
		10 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	' Prepares.
	print "Running plugin: Import sequence...";
	d = nil
	f = nil
	n = nil
	e = nil
	w = 0
	h = 0
	' Gets the asset information.
	v = get_frame_size()
	unpack(v, w, h)
	' Gets a file seed.
	f = open_file_dialog("png,bmp,tga,jpg")
	if not f then
		return
	endif
	t = split_file_with_number_postfix(f)
	d = get(t, 0)
	f = get(t, 1)
	n = get(t, 2)
	e = get(t, 3)
	' Sorts the file list to be imported.
	di = directory_info(d)
	p = f + "*" + e
	fis = di.get_files(p)
	l = list()
	for fi in fis
		p = get_full_path(fi)
		t = split_file_with_number_postfix(p)
		n = get(t, 2)
		if n = "" then
			n = nil
		else
			n = val(n)
		endif
		push(l, n)
	next
	sort(l)
	' Checks whether the last frame is blank.
	set_frame_index(0)
	b = is_frame_blank(0)
	' Imports the files.
	j = 0
	for i in l
		' Reads the image.
		if i = nil then
			p = d + f + e
		else
			p = d + f + str(i) + e
		endif
		g = image()
		g.load(p)
		if g.len(0) <> w or g.len(1) <> h then
			g.resize(w, h)
		endif
		' Adds a frame.
		if j = 0 then
			if not b then
				push_operation("add")
			endif
		else
			push_operation("add")
		endif
		n = get_frame_count()
		set_frame_index(n)
		j = j + 1
		' Fills the frame.
		begin_operation("Fill frame")
		for y = 0 to w - 1
			for x = 0 to h - 1
				c = g.get(x, y)
				c = get_palette_from_color(c)
				set_pixel(x, y, c)
			next
		next
		end_operation()
	next
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
