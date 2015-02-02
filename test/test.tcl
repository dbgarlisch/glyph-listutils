#
# Copyright 2015 (c) Pointwise, Inc.
# All rights reserved.
#
# This sample script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

source [file join [file dirname [info script]] .. "listutils.tcl"]
#namespace import pw::listutils::*

proc test_lproduct_for { desc args } {
    puts {}
    puts "foreach ${desc}: [list {*}$args]"
    set cnt 0
    pw::listutils lproduct for result {*}$args {
	puts [format "  product %3d: %s" [incr cnt] $result]
    }
}


#============================================================================
#============================================================================
proc test_lproduct_get { desc args } {
    puts {}
    puts "get ${desc}: [list {*}$args]"
    puts "  [list [pw::listutils lproduct get {*}$args]]"
}


set s1 {1a 1b {}}
set s2 {2a 2b}
set s3 {3a 3b 3c 3d}

set cnt 0
test_lproduct_for "test [incr cnt]" $s1 $s2
test_lproduct_for "test [incr cnt]" $s1 $s3

set cnt 0
test_lproduct_get "test [incr cnt]" $s1 $s2
test_lproduct_get "test [incr cnt]" $s1 $s3


#============================================================================
#============================================================================
proc test_lmutate_for { items } {
    puts {}
    puts "foreach Permutations of [list $items]"
    set cnt 0
    pw::listutils lmutate for result $items {
	puts [format "  perm %3d: %s" [incr cnt] $result]
    }
}

proc test_lmutate_get { items } {
    set ret [pw::listutils lmutate get {*}$items]
    puts {}
    puts "get Permutations of [list $items]"
    foreach r $ret {
	puts "  [list $r]"
    }
}


set tests {
    {ONE}
    {ONE TWO}
    {a b c}
    {{a 1} {b 2} {c 3}}
    {a b c d}
    {{a 1} {b 2} {c 3 z} {d 4 x y}}
}

foreach test $tests {
    test_lmutate_get $test
    test_lmutate_for $test
}


#============================================================================
#============================================================================

proc test_lcmd { cmd args } {
    set res [lsort [pw::listutils l$cmd {*}$args]]
    set str [join $args "\} $cmd \{"]
    puts "\{$str\} = [list $res]"
}

set s0 {1 2 3}
set s1 {0 1 2 3}
set s2 {3 4 5}
set s3 {0 3 6}
set s4 {1 1 2 2 3 3 4 4 5 5}
set s5 {a b c}
set s6 {a b c d e f}

puts {}
test_lcmd union $s1 $s2
test_lcmd union $s1 $s2 $s3
test_lcmd union
test_lcmd union {} {} {}
test_lcmd union $s1 $s4

puts {}
test_lcmd intersect $s1 $s2
test_lcmd intersect $s1 $s2 $s3
test_lcmd intersect $s3 $s4
test_lcmd intersect $s4 $s5

puts {}
test_lcmd subtract $s1 $s2
test_lcmd subtract $s1 $s2 $s3
test_lcmd subtract $s3 $s4
test_lcmd subtract $s4 $s5

puts {}
test_lcmd symmetricdiff $s1 $s2
test_lcmd symmetricdiff $s1 $s2 $s3
test_lcmd symmetricdiff $s3 $s4
test_lcmd symmetricdiff $s4 $s5

puts {}
set u1 [pw::listutils lunion $s4 $s3 $s6]
test_lcmd issubset $s1 $s1
test_lcmd issubset $s1 $s0
test_lcmd issubset $u1 $s5
test_lcmd issubset $u1 $s2
test_lcmd issubset $u1 $s2 $s0 $s5
test_lcmd issubset $s1 $s2 $s3
test_lcmd issubset $s3 $s4
test_lcmd issubset $s4 $s5
test_lcmd issubset $s6 $s5
