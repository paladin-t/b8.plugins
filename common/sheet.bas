REM BASIC8
REM Copyright (C) 2017 - 2018 Tony Wang
REM Plugin program of BASIC8.

import "common/frame"

' Imports an image sheet to sprite asset.
' @param f - File to be imported.
' @param xc - Slice count at x-axis.
' @param yc - Slice count at y-axis.
' @parap st - Whether stretches the image, when the size doesn't match.
def import_sheet_file(f, xc, yc, st)
	' Gets the asset information.
	w = 0
	h = 0
	v = get_frame_size()
	unpack(v, w, h)
	tw = w * xc
	th = h * yc
	' Gets the source image.
	g = image()
	g.load(f)
	iw = g.len(0)
	ih = g.len(1)
	if (iw <> tw or ih <> th) and st then
		g.resize(tw, th)
		iw = tw
		ih = th
	endif
	sw = iw / xc
	sh = ih / yc
	' Checks whether the last frame is blank.
	set_frame_index(0)
	b = is_frame_blank(0)
	' Loads the slices.
	for j = 0 to yc - 1
		offy = j * sh + (sh - h) / 2
		for i = 0 to xc - 1
			offx = i * sw + (sw - w) / 2
			' Adds a frame.
			if i = 0 and j = 0 then
				if not b then
					push_operation("add")
				endif
			else
				push_operation("add")
			endif
			n = get_frame_count()
			set_frame_index(n)
			' Fills the frame.
			begin_operation("Fill frame")
			x0 = i * sw
			x1 = x0 + sw - 1
			y0 = j * sh
			y1 = y0 + sh - 1
			for y = 0 to w - 1
				for x = 0 to h - 1
					p = x + offx
					q = y + offy
					if p >= x0 and p <= x1 and q >= y0 and q <= y1 then
						c = g.get(p, q)
						c = get_palette_from_color(c)
					else
						c = 0
					endif
					set_pixel(x, y, c)
				next
			next
			end_operation()
		next
	next
	' Marks the asset dirty.
	set_asset_unsaved()
enddef
