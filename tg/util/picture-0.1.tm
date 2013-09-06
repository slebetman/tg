namespace eval tg {
	proc picture {x y map picture} {
        array set color $map
        
        set ret [goto $x $y]
        foreach line [split [string trim $picture] \n] {
			set prevchar ""
            foreach char [split [string trim $line] ""] {
				if {$char != $prevchar} {
					set prevchar $char
					
    	            if {[info exists color($char)]} {
						append ret [color -bg $color($char)]
					} else {
						append ret [color -style none]
					}
				}
				append ret " "
            }
            append ret [goto $x [incr y]]
        }
        
        return $ret
    }
}