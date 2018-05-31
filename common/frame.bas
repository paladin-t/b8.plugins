REM BASIC8
REM Copyright (C) 2017 - 2018 Tony Wang
REM Plugin program of BASIC8.

import "common/utils"

' Gets all pixels within an area in the current asset context.
' @param x0 - X position.
' @param y0 - Y position.
' @param w - Width of an area.
' @param h - Height of an area.
' @return - Returns a dictionary with hash value as key, pixel data as value.
def get_pixels_rect(x0, y0, w, h)
	d = dict()
	for j = 0 to h - 1
		y = y0 + j
		for i = 0 to w - 1
			x = x0 + i
			k = hash_xy(x, y, w)
			c = get_pixel(x, y)
			set(d, k, c)
		next
	next
	return d
enddef

' Checks whether the current frame is blank in the current asset context.
' @param t - Transparent palette index.
' @return - Returns true if it's blank.
def is_frame_blank(t)
	w = 0
	h = 0
	v = get_frame_size()
	unpack(v, w, h)
	for j = 0 to h - 1
		for i = 0 to w - 1
			c = get_pixel(i, j)
			if c <> t then
				return false
			endif
		next
	next
	return true
enddef
