namespace eval tg {
	namespace eval line {
		proc slope {x y} {
			foreach axis {x y} {
				foreach n {1 2} {
					set thisvar "${axis}${n}"
					set othervar "[set $axis]${n}"
					upvar 1 $othervar $thisvar
				}
			}
			
			set dx [expr {$x2-$x1}]
			
			# For all intents and purposes this is good enough
			# to return in case of divide by zero:
			if {$dx == 0} {
				return 999999999
			}
			
			expr {double($y2-$y1)/$dx}
		}
	
		proc axis {dx dy} {
			if {abs($dx) > abs($dy)} {
				return {x y}
			}
			return {y x}
		}
	
		proc direction {n} {
			if {$n > 0} {
				return 1
			} elseif {$n < 0} {
				return -1
			}
			return 0
		}
		
		proc val {args} {
			upvar 1 [join $args ""] v
			return $v
		}
		
		proc var {args} {
			return [join $args ""]
		}
		
		proc pixel {x y prev} {
			upvar 1 $prev yy
			
			if {$y != $yy} {
				set yy $y
				return "[tg::goto $x $y] "
			}
			append ret " "
		}
	}
	
	# Very crude line drawing algorithm inspired by/based on
	# the Bresenham line algorithm.
	#
	proc line {x1 y1 x2 y2 {color reverse}} {
		set dx [expr {$x2-$x1}]
		set dy [expr {$y2-$y1}]
		
		lassign [line::axis $dx $dy] a b
		set a_dir [line::direction [line::val d $a]]
		set b_dir [line::direction [line::val d $b]]
		
		# First we calculate a reference slope:
		#
		set slope [line::slope $a $b]
		set prev_y ""
		
		while {[line::val $a 1] != [line::val $a 2]} {
			append ret [line::pixel $x1 $y1 prev_y]
			
			# Then we advance in the major axis
			# (the axis where the slope is shallower)
			# one pixel at a time.
			#
			incr [line::var $a 1] $a_dir
			set newslope [line::slope $a $b]
			
			# Then we check to see if incrementing the minor axis
			# by one pixel results in a slope that is more similar
			# to the original reference slope. If not we don't
			# increment the minor axis and continue looping.
			#
			incr [line::var $b 1] $b_dir
			set testslope [line::slope $a $b]
			
			if {(abs($testslope-$slope)) > (abs($newslope-$slope))} {
				incr [line::var $b 1] [expr {$b_dir * -1}]
			}
		}
		append ret [line::pixel $x1 $y1 prev_y]
		
        return [with_bg_color $color {give $ret}]
    }
	
	proc polyline {coords {color reverse}} {
		set coords [lassign $coords x1 y1]
		
		set ret ""
		foreach {x2 y2} $coords {
			append ret [line $x1 $y1 $x2 $y2 $color]
			lassign [list $x2 $y2] x1 y1
		}
		return $ret
	}
}