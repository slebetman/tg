package require tg

namespace eval tg::sprite {
    variable last_id 0
    array set animations {}

    proc load {filename} {
        set f [open $filename]
        set spritedata [read $f]
        close $f
        
        return $spritedata
    }
    
    proc draw {x y sprite index} {
        incr index
        tg::picture $x $y [lindex $sprite 0] [lindex $sprite $index]
    }
	
	namespace eval animate {
		proc loop {x y  sprite delay rendercmd index id} {

			set mods [$rendercmd [tg::sprite::draw $x $y $sprite $index] $x $y $sprite $id]
			
			foreach {var val} $mods {
				switch $var {
					x -
					y -
					sprite {
						set $var $val
					}
					default {
						error "Unsupported variable in return dict: $var"
					}
				}
			}
			
			set index [expr {($index+1)%([llength $sprite]-1)}]
		
			set animations($id) [after $delay [
				list tg::sprite::animate::loop $x $y $sprite $delay $rendercmd $index $id]
			]
		}
	}
    
    proc animate {x y sprite delay rendercmd} {
        variable last_id
        variable animations
        
        set id [incr last_id]
		animate::loop $x $y $sprite $delay $rendercmd 0 $id      
        return $id
    }
	
    proc changeColor {sprite search replace} {
        set colorSpec [lindex $sprite 0]
        
        set newColors {}
        foreach {char color} $colorSpec {
            if {$char == $search || $color == $search} {
                set color $replace
            }
            lappend newColors $char $color
        }
        
        lreplace $sprite 0 0 $newColors
    }
    
    proc reverse {sprite} {
        set newsprite [list [lindex $sprite 0]]
        
        foreach pic [lrange $sprite 1 end] {
            set newpic {}
            foreach line [split $pic \n] {
                append newpic "[string reverse $line]\n"
            }
            lappend newsprite $newpic
        }
        
        return $newsprite
    }
    
    proc stopanimation {id} {
        variable animations
        
        after cancel $animations($id)
    }
}
