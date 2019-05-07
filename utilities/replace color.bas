REM BASIC8
REM Copyright (C) 2017 - 2019 Tony Wang
REM Plugin program of BASIC8.

REM Loads the plugin.

def plug()
	print "Loading plugin: Replace color...";
	register_plugin
	(
		"sprite, tiles, quantized", ' Target assets.
		"Replace color", ' Name.
		"Replace all pixels in the color at the specified position with the active palette", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		10, ' Category.
		20 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	' Prepares.
	print "Running plugin: Replace color...";
	src = 0
	tgt = 0
	' Gets the source and target colors.
	p = get_cursor_position()
	if p = nil then
		return
	endif
	x = 0
	y = 0
	unpack(p, x, y)
	src = get_pixel(x, y)
	tgt = get_source_index()
	if src = tgt then
		return
	endif
	' Sets with the new color.
	begin_operation("Replace color")
	v = get_frame_size()
	unpack(v, w, h)
	for j = 0 to h - 1
		for i = 0 to w - 1
			c = get_pixel(i, j)
			if c = src then
				set_pixel(i, j, tgt)
			endif
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
