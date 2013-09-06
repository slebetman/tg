namespace eval tg::font {
    proc load {filename} {
        set f [open $filename]
        set fontdata [read $f]
        close $f
        
        parse $fontdata
    }
    
    proc parse {fontdata} {
        array set fontmap $fontdata
        if {[::info exists fontmap(info)]} {
            array set fontinfo $fontmap(info)
            
            foreach {char bits} $fontdata {
                if {$char != "info" && [string length $char] == 1} {
                    lappend fontdata ${char}.width [string length [
                        string trim [
                            lindex [
                                split [
                                    string trim $fontmap($char)
                                ]
                            ] 0
                        ]
                    ]]
                }
            }
            
            variable $fontinfo(name)
            set $fontinfo(name) $fontdata
        } else {
            error "Info not found in font file"
        }
    }
    
    proc info {fontname {attr "all"}} {
        variable $fontname
        array set fontmap [set $fontname]
        
        switch $attr {
            all {
                return $fontmap(info)
            }
            default {
                array set fontinfo $fontmap(info)
                return $fontinfo($attr)
            }
        }
    }
}

# Load default test font:
tg::font::parse {
	info {
		name testfont
		height 6
		baseline 5
		overhang 0
	}
	. {
		.
		.
		.
		.
		#
	}
	, {
		..
		..
		..
		.#
		#.
	}
	! {
		#
		#
		#
		.
		#
	}
	? {
		##.
		..#
		.#
		.
		.#
	}
	" " {.}
	1 {
		##.
		.#
		.#
		.#
		###
	}
	2 {
		##.
		..#
		.#
		#
		###
	}
	3 {
		##.
		..#
		##
		..#
		##
	}
	4 {
		#.#
		#.#
		###
		..#
		..#
	}
	5 {
		###
		#
		##
		..#
		##
	}
	6 {
		.#.
		#
		##
		#.#
		.#
	}
	7 {
		###
		..#
		.#
		#
		#
	}
	8 {
		.#.
		#.#
		.#
		#.#
		.#
	}
	9 {
		.#.
		#.#
		.##
		..#
		.#
	}
	0 {
		.#.
		#.#
		#.#
		#.#
		.#
	}
	A {
		.##
		#.#
		###
		#.#
		#.#
	}
	B {
		##.
		#.#
		##.
		#.#
		##
	}
	C {
		.##
		#..
		#..
		#..
		.##
	}
	D {
		##.
		#.#
		#.#
		#.#
		##.
	}
	E {
		###
		#.
		##
		#.
		###
	}
	F {
		###
		#.
		##
		#.
		#.
	}
	G {
		.##
		#...
		#.#
		#.#
		.##
	}
	H {
		#.#
		#.#
		###
		#.#
		#.#
	}
	I {
		#
		#
		#
		#
		#
	}
	J {
		..#
		..#
		..#
		#.#
		.#.
	}
	K {
		#..#
		#.#
		##..
		#.#.
		#..#
	}
	L {
		#.
		#
		#
		#
		##
	}
	M {
		#...#
		##.##
		#.#.#
		#...#
		#...#
	}
	N {
		#..#
		##.#
		#.##
		#..#
		#..#
	}
	O {
		.#.
		#.#
		#.#
		#.#
		.#.
	}
	P {
		##.
		#.#
		##
		#
		#
	}
	Q {
		.##.
		#..#
		#..#
		#.##
		.#.#
	}
	R {
		##.
		#.#
		##
		#.#
		#.#
	}
	S {
		.##
		#..
		.#.
		..#
		##
	}
	T {
		###
		.#
		.#
		.#
		.#
	}
	U {
		#.#
		#.#
		#.#
		#.#
		###
	}
	V {
		#..#
		#..#
		#.#
		##
		#
	}
	W {
		#...#
		#...#
		#.#.#
		##.##
		#...#
	}
	X {
		#.#
		#.#
		.#
		#.#
		#.#
	}
	Y {
		#.#
		#.#
		.##
		..#
		##
	}
	Z {
		###
		..#
		.#
		#
		###
	}
	a {
		...
		##
		.##
		#.#
		###
	}
	b {
		#..
		#
		##
		#.#
		##
	}
	c {
		...
		.
		.##
		#
		.##
	}
	d {
		..#
		..#
		.##
		#.#
		.##
	}
	e {
		...
		.##
		#.#
		##
		###
	}
	f {
		..#
		.#.
		###
		.#.
		.#.
	}
	g {
		...
		.##
		#.#
		.##
		..#
		##
	}
	h {
		#..
		#
		##
		#.#
		#.#
	}
	i {
		#
		.
		#
		#
		#
	}
	j {
		..#
		...
		..#
		..#
		#.#
		.#
	}
	k {
		#..
		#
		#.#
		##.
		#.#
	}
	l {
		#
		#
		#
		#
		#
	}
	m {
		.....
		.....
		##.##
		#.#.#
		#...#
	}
	n {
		....
		....
		###
		#..#
		#..#
	}
	o {
		...
		...
		###
		#.#
		###
	}
	p {
		...
		##.
		#.#
		##
		#
		#
	}
	q {
		...
		.##
		#.#
		.##
		..#
		..#
	}
	r {
		..
		.
		##
		#
		#
	}
	s {
		..
		##
		#.
		.#
		##
	}
	t {
		.#.
		.#
		###
		.#
		.#
	}
	u {
		...
		...
		#.#
		#.#
		###
	}
	v {
		...
		...
		#.#
		##
		#
	}
	w {
		.....
		.....
		#.#.#
		##.##
		#...#
	}
	x {
		...
		...
		#.#
		.#
		#.#
	}
	y {
		...
		...
		#.#
		.##
		..#
		##
	}
	z {
		..
		##
		.#
		#
		##
	}
}