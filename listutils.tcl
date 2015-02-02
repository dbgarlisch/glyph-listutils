#
# Copyright 2015 (c) Pointwise, Inc.
# All rights reserved.
#
# This sample script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

if { [namespace exists pw::listutils] } {
  return
}

# See: http://en.wikipedia.org/wiki/Set_(mathematics)

#  pw::listutils <cmd> ?<options>?

namespace eval pw::listutils {

    # pw::listutils lproduct <subcmd> ?<options>?
    #   pw::listutils lproduct get <list> ?<list> ...?
    #   pw::listutils lproduct foreach <varname> <list> ?<list> ...? <body>
    namespace export lproduct
    proc lproduct { subCmd args } {
      return [lproduct_${subCmd} {*}$args]
    }


    # pw::listutils lmutate <subcmd> ?<options>?
    #   pw::listutils lmutate get <list>
    #   pw::listutils lmutate foreach <varname> <list> <body>
    namespace export lmutate
    proc lmutate { subCmd args } {
      return [lmutate_${subCmd} {*}$args]
    }


    # pw::listutils lunion ?<list> ...?
    namespace export lunion
    proc lunion { args } {
      set d [dict create]
      # $args is a list of lists
      foreach arg $args {
	# for each val in the list...
	foreach val $arg {
	  # create an entry in the dict d
	  dict set d $val 1
	}
      }
      # grab unique keys from dict which is the union
      return [dict keys $d]
    }


    # pw::listutils lintersect <list> <list> ?<list> ...?
    namespace export lintersect
    proc lintersect { A B args } {
      set d [dict create]
      set B [lsort -unique $B]
      foreach val $A {
	if { -1 != [lsearch -sorted $B $val] } {
	  dict set d $val 1
	}
      }
      if { 0 != [llength $args] } {
	# recursively intersect with additional lists
	set ret [lintersect [dict keys $d] {*}$args]
      } else {
	# no more lists, we are done
	set ret [dict keys $d]
      }
      return $ret
    }


    # pw::listutils lsubtract <list> <list> ?<list> ...?
    namespace export lsubtract
    proc lsubtract { A B args } {
      set d [dict create]
      set B [lsort -unique $B]
      foreach val $A {
	if { -1 == [lsearch -sorted $B $val] } {
	  dict set d $val 1
	}
      }
      if { 0 != [llength $args] } {
	# recursively subtract with additional lists
	set ret [lsubtract [dict keys $d] {*}$args]
      } else {
	# no more lists, we are done
	set ret [dict keys $d]
      }
      return $ret
    }


    # pw::listutils lsymmetricdiff <list> <list> ?<list> ...?
    namespace export lsymmetricdiff
    proc lsymmetricdiff { A B args } {
      # == (A - B) union (B - A)
      set ret [lunion [lsubtract $A $B] [lsubtract $B $A]]
      if { 0 != [llength $args] } {
	# recursively lsymmetricdiff with additional lists
	set ret [lsymmetricdiff $ret {*}$args]
      }
      return $ret
    }


    # pw::listutils lissubset <superlist> <sublist> ?<sublist> ...?
    namespace export lissubset
    proc lissubset { superlist sublist args } {
      set superlist [lsort $superlist]
      set ret 1
      while { $ret } {
	foreach val $sublist {
	  if { -1 == [lsearch -sorted $superlist $val] } {
	    set ret 0
	    break
	  }
	}
	if { 0 == [llength $args] } {
	  break
	}
	set args [lassign $args sublist]
      }
      return $ret
    }


    #================================================================
    # PRIVATE lproduct IMPL PROCS
    #================================================================

    # pw::listutils lproduct foreach <varname> <list> ?<list> ...? <body>
    proc lproduct_for { varName args } {
      if { 2 > [llength $args] } {
	error "Invalid number of args: lproduct foreach <varname> <list> ?<list> ...? <body>"
      }
      lproduct_for_level 3 $varName {*}$args
    }

    # pw::listutils lproduct get <list> ?<list> ...?
    proc lproduct_get { args } {
      if { 1 > [llength $args] } {
	error "Invalid number of args: lproduct get <list> ?<list> ...?"
      }
      set ret [list]
      lproduct_for_level 2 combo {*}$args {
	lappend ret $combo
      }
      return $ret
    }

    # pw::listutils lproduct foreach <varname> <list> ?<list> ...? <body>
    proc lproduct_for_level { level varName args } {
      set body [lindex $args end]
      set args [lassign [lrange $args 0 end-1] vals]
      if { 0 == [llength $vals] } {
	set vals [list {}]
      }
      foreach val $vals {
	lproduct_forR $varName $level [list $val] $body {*}$args
      }
    }

    #  combo lproduct_forR varName level subCombo body ?<list> ...?
    proc lproduct_forR { varName level subCombo body args } {
      #puts "[string repeat {  } $level]lproduct_forR $varName level($level) subCombo($subCombo) body args($args)"
      if { 0 == [llength $args] } {
	# no more sets
	upvar $level $varName combo
	set combo $subCombo
	uplevel $level $body
      } else {
	incr level
	set args [lassign $args vals]
	if { 0 == [llength $vals] } {
	  set vals [list {}]
	}
	foreach val $vals {
	  set tmp $subCombo
	  lappend tmp $val
	  lproduct_forR $varName $level $tmp $body {*}$args
	}
      }
    }


    #================================================================
    # PRIVATE lmutate IMPL PROCS
    #================================================================

    #  pw::listutils lmutate get <list>
    proc lmutate_get { args } {
      set ret [list]
      lmutate_for_level 1 0 perm $args {
	lappend ret $perm
      }
      return $ret
    }

    #  pw::listutils lmutate foreach <varname> <list> <body>
    proc lmutate_for { varName items body } {
      lmutate_for_level 3 0 $varName $items $body
    }

    proc lmutate_for_level { level ndx varName items body } {
      set ret [list]
      set cnt [llength $items]
      if { $ndx == $cnt } {
	# At the end of the array, we have one permutation we can use.
	upvar $level $varName perm
	set perm $items
	uplevel $level $body
      } else {
	# Recursively explore the permutations starting at index ndx going
	# through index cnt-1
	incr level
	set ndxPlus1 [expr {$ndx + 1}]
	for {set ii $ndx} {$ii < $cnt} {incr ii} {
	  # try the array with ndx and ii switched
	  swap items $ndx $ii
	  set ret [concat $ret [lmutate_for_level $level $ndxPlus1 $varName $items $body]]
	  # swap them back the way they were
	  swap items $ndx $ii
	}
      }
      return $ret
    }

    proc swap { itemsVar ndx1 ndx2 } {
      upvar $itemsVar items
      set t [lindex $items $ndx1]
      lset items $ndx1 [lindex $items $ndx2]
      lset items $ndx2 $t
    }

    namespace ensemble create
}
