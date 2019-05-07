REM BASIC8
REM Copyright (C) 2017 - 2019 Tony Wang
REM Plugin program of BASIC8.

' Gets the hash value of a given point.
' @param x - X position.
' @param y - Y position.
' @param w - Width of an area.
' @return - Integer denotes for a unique value within a given area.
def hash_xy(x, y, w)
	return x + y * w
enddef

' Validates an image file path, appends extension name if necessary.
' @param f - File path to be validated.
' @return - Valid image path.
def validate_image_file(f)
	e = right(f, 4)
	if e = ".png" then return f
	if e = ".bmp" then return f
	if e = ".tga" then return f
	if e = ".jpg" then return f
	return f + ".png" ' Defaults to PNG.
enddef

' Splits a file path into parts.
' @param f - File path to be splitted.
' @return - Splitted directory path, file name, number postfix, and extension name.
def split_file_with_number_postfix(f)
	' Separates the extension name.
	l = len(f)
	for i = l - 1 to 0 step -1
		if mid(f, i, 1) = "." then
			exit
		endif
	next
	e = ""
	if i > 0 then
		e = right(f, l - i)
		f = left(f, i)
	endif
	' Separates the number postfix.
	l = len(f)
	for i = l - 1 to 0 step -1
		c = mid(f, i, 1)
		c = asc(c)
		if c < asc("0") or c > asc("9") then
			exit
		endif
	next
	n = ""
	if i < l - 1 then
		n = right(f, l - i - 1)
		f = left(f, i + 1)
	endif
	' Separates the file name.
	l = len(f)
	for i = l - 1 to 0 step -1
		c = mid(f, i, 1)
		if c = "/" or c = "\" then
			exit
		endif
	next
	if i = l - 1 then
		d = left(f, i + 1)
		f = ""
	else
		d = left(f, i + 1)
		f = right(f, l - i - 1)
	endif
	' Returns the result.
	return list(d, f, n, e)
enddef
