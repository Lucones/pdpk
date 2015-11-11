#! /bin/env tclsh

package require Tk
package require zlib

set types {
    {{Text Files}       {.txt}        }}
    set file [tk_getOpenFile -multiple 1 -filetypes $types -parent .]

	#exec zip -j myfiles.zip [tk_getOpenFile -multiple 1 -filetypes $types -parent .]
	
	#exec zip -j package.zip {*}$file
	
	exec {*}[auto_execok start] zip -j package.zip {*}$file
