package require tg::font

namespace eval tg {
	proc write {x y font color text} {
		set ret ""
		array set fontmap [set tg::font::$font]
		foreach char [split $text ""] {
			if {![info exists fontmap($char)]} {
				set char [string tolower $char]
			}
			if {[info exists fontmap($char)]} {
				append ret [picture $x $y  [list "#" $color] $fontmap($char)]
				incr x [expr {$fontmap(${char}.width) + 1}]
			}
		}
		return $ret
	}
}
