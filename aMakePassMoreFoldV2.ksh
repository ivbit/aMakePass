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
# The script creates text file aPasswdsMore.txt
# with 100 passwords of user defined length.
# If invalid length is specified (>128 or <1),
# the value 30 is used.
# This script runs very fast.
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
integer passLength=30
# 100 symbols array for picking random symbols
# Symbol / (number 47), if present, interferes with sed
set -A randSymbols -- $(jot -c 4 35 38
jot -c 7 40 46
jot -c 44 48 91
jot -c 3 93 95
jot -c 30 97 126
jot -c 7 64 58
jot -c 3 125 123
jot -r -c 2 35 38)
# Declare variables END

# BEGINNING OF SCRIPT
(( $# == 1 )) && testSetPL "$1" ||
  {
    print -n -- "Enter password's length: "
    read --
    testSetPL "$REPLY"
  }

# Generate string with all characters
# and pass it to fold for processing,
# run sed to replace unwanted \`'" and duplicated symbols,
# then save result into aPasswdsMore.txt, overwriting it.
jot -r -c -s '' ${passLength}00 '35.01' 126 |
  fold -w $passLength |
    sed -e "s/[\\\`][\\\`]/${randSymbols[RANDOM%100]}${randSymbols[RANDOM%100]}/g" -e "s/^[\\\`]/${randSymbols[RANDOM%100]}/g" -e "s/[\\\`]$/${randSymbols[RANDOM%100]}/g" -e "s/[\\\`]/!/g" -e "s/'/~/g" -e "s/\(.\)\1/${randSymbols[RANDOM%100]}${randSymbols[RANDOM%100]}/g" -e "s/\(.\)\1/${randSymbols[RANDOM%100]}${randSymbols[RANDOM%100]}/g" >| aPasswdsMore.txt

# Shell settings START
set +o noglob
# Shell settings END

# END OF SCRIPT

