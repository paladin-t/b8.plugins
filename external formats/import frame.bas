REM BASIC8
REM Copyright (C) 2017 - 2019 Tony Wang
REM Plugin program of BASIC8.

REM Imports common modules.

REM Loads the plugin.

def plug()
	print "Loading plugin: Import frame...";
	register_plugin
	(
		"sprite, quantized", ' Target assets.
		"Import frame", ' Name.
		"Import a frame of image to the current asset", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		30, ' Category.
		50 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	' Prepares.
	print "Running plugin: Import frame...";
	w = 0
	h = 0
	' Gets the asset information.
	v = get_frame_size()
	unpack(v, w, h)
	' Gets a file.
	f = open_file_dialog("png,bmp,tga,jpg")
	if not f then
		return
	endif
	' Gets the source frame.
	g = image()
	g.load(f)
	iw = g.len(0)
	ih = g.len(1)
	if iw <> w or ih <> h then
		g.resize(w, h)
		iw = w
		ih = h
	endif
	' Fills the frame.
	begin_operation("Fill frame")
	for j = 0 to h - 1
		for i = 0 to w - 1
			c = g.get(i, j)
			c = get_palette_from_color(c)
			set_pixel(i, j, c)
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
