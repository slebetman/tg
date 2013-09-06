namespace eval tg {

    proc ESC {} {
        return "\\e"
    }
}

proc echo {args} {
	set newline ""
	set chan stdout
	set txt ""
	
	switch [llength $args] {
		1 {
			lassign $args txt
		}
		2 {
			lassign $args chan txt
		}
		3 {
			lassign $args newline chan txt
			if {$newline == "-nonewline"} {
				set newline "-n"
			} else {
				set newline ""
			}
		}
		default {
			return [puts {*}$args]
		}
	}
	
	set oldmap {
		\" \\\"
		' \\'
		( \\(
		) \\)
		\[ \\\[
		] \\]
		$ \\$
		\n \\n
		& \\&
		| \\|
		; \\;
	}
	
	set txt [string map {
		\" \\\"
		' \\'
		\n \\n
	} $txt]
	
	puts $chan "echo $newline -e '$txt'"
}
