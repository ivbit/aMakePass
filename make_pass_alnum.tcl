#! /bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

# /bin/sh executes tclsh with arguments, if any.
# If there are no arguments, first argument $1 is unset in sh.
# If first argument $1 is set, 'sh' replaces it with all arguments $@.
# tclsh interprets backslash as continuation of the comment string, sh does not.

# man tclsh

# Intellectual property information START
#
# Copyright (c) 2024 Ivan Bityutskiy
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# Intellectual property information END

# Description START
#
# The script produces 27 unique passwords with user defined length (1..=62).
# Modify 'passLines' variable to produce different amount of passwords.
# Modify 'charList' variable to use different characters.
#
# Usage:
# ./make_pass_alnum.tcl
# OR
# Start tclsh and source ./make_pass_alnum.tcl, then call printResult
# tclsh
# source ./make_pass_alnum.tcl
# printResult
# Description END

# Amount of passwords to produce
set passLines 27

# List with all symbols allowed in passwords
set charList {
    0 1 2 3 4 5 6 7 8 9 A B C D E F
    G H I J K L M N O P Q R S T U V
    W X Y Z a b c d e f g h i j k l
    m n o p q r s t u v w x y z
}

# Maximum password's length
set maxValue [llength $charList]

# Get user input, trim leading zeroes
proc getUserInput {} {
  chan puts -nonewline stdout "\nEnter password's length (1..=$::maxValue): "
  chan flush stdout
  set ::userNum [string trimleft [string trim [chan gets stdin]] 0]
  return 1
}

# Check user input
# 'digit' character class always works with Unicode characters:
# string is digit \u096a
# returns '1' because '\u096a' is a valid unicode digit, however:
# string is integer \u096a
# returns '0'
proc checkUserInput {} {
  expr {
    [string is integer -strict $::userNum] &&
    [string is digit -strict $::userNum] &&
    $::userNum > 0 &&
    $::userNum <= $::maxValue
  }
}

# Get 1st argument, or ask user for an input; trim leading zeroes
expr {
  $argc > 0 &&
  [set userNum [string trimleft [string trim [lindex $argv 0]] 0]; string cat 1] &&
  [checkUserInput] ||
  [getUserInput] &&
  [checkUserInput] ||
  [set userNum $maxValue]
}

# Get true random numbers from /dev/urandom on *nix systems:
# How many bytes to read at once (8 bytes = 64 bits = 64 bit integer)
set readSingle 8
# How many integers are needed
# Multiply by 10 to make sure there are enough integers for duplicate characters
set readAll [expr {$readSingle * $userNum * 10}]

# Procedure will read all the data from /dev/urandom in a single step and store
# it in a list. This is a better solution than reading from /dev/urandom every
# single time, opening and closing the file. For example instead of opening and
# closing /dev/urandom 100 times, it will be done only once.
proc genRandList {maxValue amtBytes} {
  set devUrandom [open /dev/urandom rb]
  # Convert binary data into unsigned integers for future use:
  # Order can be 'little endian', 'big endian', or 'native' for the CPU;
  # m = 64 bit integer in native order; n = 32 bit integer in native order;
  # u = unsigned flag; * = count, all bytes will be stored in one variable
  binary scan [chan read $devUrandom $amtBytes] mu* randList
  chan close $devUrandom
  # Store random numbers in a list
  foreach {num} $randList {
    lappend randResult [expr {$num % $maxValue}]
  }
  return $randResult
}

# Procedure will generate the password
proc genPassword {} {
  global charList
  set pwStr {}
  foreach {randNum} [genRandList $::maxValue $::readAll] {
    set theChar [lindex $charList $randNum]
    if {![string match *\\${theChar}* $pwStr]} then {
      append pwStr $theChar
    }
  }
  set pwStr [string range $pwStr 0 $::userNum-1]
  # Return the password
  return $pwStr
}

# Procedure to print the password
proc printResult {} {
  set decrNum $::passLines
  chan puts stdout {}
  while {$decrNum ^ 0} {
    incr decrNum -1
    chan puts stdout [genPassword]
  }
  chan puts stdout {}
}

# Print the password
printResult

# END OF SCRIPT

