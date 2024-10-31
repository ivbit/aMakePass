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
# The script trims the input string to a desirable length.
# Modify 'outputLength' variable to change desirable output string length.
#
# Usage:
# ./trim_pstring.tcl
# OR
# ./trim_pstring.tcl integer_argument:
# ./trim_pstring.tcl 74
# Description END

# Output string length
set outputLength 124

# Get user input, trim leading zeroes
proc getUserInput {} {
  chan puts -nonewline stdout "\nOutput string length (1..=$::outputLength): "
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
    $::userNum <= $::outputLength
  }
}

# Get 1st argument, or ask user for an input; trim leading zeroes
expr {
  $argc > 0 &&
  [set userNum [string trimleft [string trim [lindex $argv 0]] 0]; string cat 1] &&
  [checkUserInput] ||
  [getUserInput] &&
  [checkUserInput] ||
  [set userNum $outputLength]
}

# Ask user to input the string; print the result
chan puts stdout "Input string:"
chan puts stdout [string repeat M $userNum]
chan flush stdout
set userStr [string trim [chan gets stdin]]
chan puts stdout "\n[string range $userStr 0 $userNum-1]\n"

# END OF SCRIPT

