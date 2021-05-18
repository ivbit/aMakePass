#!/bin/ksh

# Intellectual property information START
# 
# Copyright (c) 2020 Ivan Bityutskiy 
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
# The script creates text file aPasswdsAlnum.txt
# with 100 [[:alnum:]] passwords of user defined length.
# If invalid length is specified (>128 or <1),
# the value 30 is used.
# Script is 'slow' (128 symbols passwords in 0.50 seconds)
#
# Description END

# Shell settings START
set -o noglob
umask 077
# Shell settings END

# Define functions START
function testSetPL
{
  # Limit user input to 3 symbols
  local -R3 trimInput="$1"
  [[ "$trimInput" == *([[:blank:]])+([[:digit:]]) ]] &&
    (( $trimInput <= 128 && $trimInput >= 1 )) &&
      (( passLength=$trimInput ))
}
# Define functions END

# Declare variables START
integer passLength=30 num
typeset arrSymbols
# 62 [[:alnum:]] symbols (array elements from 0 to 61)
set -A arrSymbols -- $(jot -c 10 48 57
jot -c 26 65 90
jot -c 26 97 122)
# Declare variables END

# BEGINNING OF SCRIPT

# Test user input and determine variable passLength
(( $# == 1 )) && testSetPL "$1" ||
  {
    print -n -- "Enter password's length: "
    read --
    testSetPL "$REPLY"
  }

# Read random numbers from jot, use them to withdraw a
# value from the array and pass it to fold for processing,
# run sed to replace duplicated symbols,
# then save result into aPasswdsAlnum.txt, overwriting it.
jot -r -w '%d' ${passLength}00 '0.01' '61.99' |
  while read -- num
  do
    print -n -- "${arrSymbols[num]}"
  done |
    fold -w $passLength |
    sed -e "s/\(.\)\1/${arrSymbols[RANDOM%62]}${arrSymbols[RANDOM%62]}/g" -e "s/\(.\)\1/${arrSymbols[RANDOM%62]}${arrSymbols[RANDOM%62]}/g" >| aPasswdsAlnum.txt
print -- '' >> aPasswdsAlnum.txt

# Shell settings START
set +o noglob
# Shell settings END

# END OF SCRIPT

