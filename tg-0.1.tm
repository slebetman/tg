namespace eval tg {

    proc ESC {} {
        return "\033"
    }

    proc ESC_ {} {
        return "[ESC]\["
    }

    proc give {args} {
        return [join $args ""]
    }

    proc save {} {
        return "[ESC_]s"
    }

    proc restore {} {
        return "[ESC_]u"
    }

    proc saveall {} {
        return "[ESC]7"
    }

    proc restoreall {} {
        return "[ESC]8"
    }

    proc color {args} {
        # Support list and args conventions:
        if {[llength $args] == 1 && [llength [lindex $args 0]] > 1} {
            set args [lindex $args 0]
        }
        set ret [ESC_]
        foreach {op val} $args {
            switch -- $op {
                -style {}
                -bg {append ret 4}
                -fg {append ret 3}
            }
            switch -- $val {
                black     {append ret "0;"}
                red       {append ret "1;"}
                green     {append ret "2;"}
                yellow    {append ret "3;"}
                blue      {append ret "4;"}
                magenta   {append ret "5;"}
                cyan      {append ret "6;"}
                white     {append ret "7;"}
                none      {append ret "0;"}
                bright    {append ret "1;"}
                dim       {append ret "2;"}
                underline {append ret "4;"}
                blink     {append ret "5;"}
                reverse   {append ret "7;"}
            }
        }
        set ret [string trim $ret ";"]
        return ${ret}m
    }

    proc repeat {count code} {
        set ret ""
        while {[incr count -1] >= 0} {
            append ret [uplevel 1 $code]
        }
        return $ret
    }

    proc goto {x y} {
        return "[ESC_]${y};${x}H"
    }

    proc go {direction {count 1}} {
        return [ESC_]$count[
            switch $direction {
                up {give A}
                down {give B}
                left {give D}
                right {give C}
            }
        ]
    }

    proc clear {} {
        return "[ESC_]2J"
    }

    proc clearline {} {
        return "[ESC_]2K"
    }

    proc set_bg_color {color} {
        switch $color {
            reverse {return "-style $color"}
            default {return "-bg $color"}
        }
    }

    proc with_bg_color {color code} {
        set color [set_bg_color $color]
        return [
            color $color ][
            uplevel 1 $code ][
            color -style none
        ]
    }

    proc do_sub {code} {
        return [
            saveall ][
            uplevel 1 $code ][
            restoreall
        ]
    }

    proc hline {x y width {color reverse}} {
        return [with_bg_color $color {
            give [
                goto $x $y ][
                string repeat " " $width
            ]
        }]
    }

    proc vline {x y height {color reverse}} {
        return [with_bg_color $color {
            give [
                goto $x $y ][
                repeat $height {
                    give " [go down][go left]"
                }
            ]
        }]
    }

    proc box {x1 y1 x2 y2 {color reverse}} {
        set width [expr {$x2-$x1+1}]
        set height [expr {$y2-$y1+1}]
        return [
            hline $x1 $y1 $width $color ][
            hline $x1 $y2 $width $color ][
            vline $x1 $y1 $height $color ][
            vline $x2 $y1 $height $color
        ]
    }
}

package require tg::util::line
package require tg::util::picture
