namespace eval tg {
    proc picture {x y map picture} {
        array set color $map
        
        set ret [goto $x $y]
        foreach line [split [string trim $picture] \n] {
            foreach char [split [string trim $line] ""] {
                if {[info exists color($char)]} {
                    append ret $char
                } else {
					append ret " "
                }
            }
            append ret [goto $x [incr y]]
        }
        
        return $ret
    }
}