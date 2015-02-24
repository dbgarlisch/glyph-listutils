#
# Copyright 2015 (c) Pointwise, Inc.
# All rights reserved.
#
# This sample script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

package require PWI_Glyph

source [file join [file dirname [info script]] .. "listutils.tcl"]
#namespace import pw::listutils::*


proc getSelection { selectedVarName } {
    upvar 1 $selectedVarName selected
    set ret 0
    #puts "  getSelection BEGIN"
    set mask [pw::Display createSelectionMask -requireConnector {}]
    #puts "mask: '$mask'"
    if { [pw::Display selectEntities -description {Select ents} \
	-selectionmask $mask picks] } {
	foreach key [array names picks] {
	    #puts "picks($key) = '$picks($key)'"
	    set selected [concat $selected $picks($key)]
	}
	#puts "selected: '$selected'"
	set ret 1
    }
    #puts "  getSelection END"
    return $ret
}


proc test_lcmd { cmd args } {
    set res [lsort [pw::listutils l$cmd {*}$args]]
    set str [join $args "\} $cmd \{"]
    puts "  \{$str\} = [list $res]"
}


proc test_lmutate_for { items } {
    puts {}
    puts "foreach Permutations of [list $items]"
    set cnt 0
    pw::listutils lmutate for result $items {
	puts [format "  perm %3d: %s" [incr cnt] $result]
    }
}


#============================================================================
#============================================================================

puts "BEGIN"
set sel1 {}
set sel2 {}
if { ![getSelection sel1] } {
    puts "  getSelection sel1 FAILED"
} elseif { ![getSelection sel2] } {
    puts "  getSelection sel2 FAILED"
} else {
    puts "  sel1: '$sel1'"
    puts "  sel2: '$sel2'"
    puts {}
    test_lcmd union $sel1 $sel2

    puts {}
    test_lcmd intersect $sel1 $sel2

    puts {}
    test_lcmd subtract $sel1 $sel2
    test_lcmd subtract $sel2 $sel1

    puts {}
    test_lcmd symmetricdiff $sel1 $sel2

    puts {}
    test_lcmd issubset $sel1 $sel2
    test_lcmd issubset $sel2 $sel1

    test_lmutate_for $sel1
    test_lmutate_for $sel2
}
puts "END"

# END SCRIPT

#
# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT. TO THE MAXIMUM EXTENT PERMITTED
# BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE
# FAULT OR NEGLIGENCE OF POINTWISE.
#
