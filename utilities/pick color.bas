REM BASIC8
REM Copyright (C) 2017 - 2018 Tony Wang
REM Plugin program of BASIC8.

REM Loads the plugin.

def plug()
	print "Loading plugin: Pick color...";
	register_plugin
	(
		"sprite, tiles, quantized", ' Target assets.
		"Pick color", ' Name.
		"Active palette with picked color", ' Tooltips.
		false, ' Selection only?
		false, ' Square only?
		10, ' Category.
		10 ' Priority.
	)
enddef

REM Runs the plugin.

def run()
	print "Running plugin: Pick color...";
	p = get_cursor_position()
	if p = nil then
		return
	endif
	x = 0
	y = 0
	unpack(p, x, y)
	i = get_pixel(x, y)
	set_source_index(i)
enddef

REM Checks the operation.

ph = get_phase()
if ph = "plug" then
	plug()
elseif ph = "run" then
	run()
endif
