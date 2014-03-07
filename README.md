tg
==

Terminal Graphics library for Tcl
---------------------------------

The tg library generates strings with control characters for VT100 compatible
terminals. You can use this library to draw fancy (crude) graphics on the terminal
or simply to create simple console interfaces.

Almost all functions in this library generate strings instead of directly printing
to the screen. This makes it easier to integrate tg into other porgrams. If all you
want to do is draw something then just remember to ***puts*** the returned string.

