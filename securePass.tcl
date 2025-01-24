#! /bin/sh
# launch \
exec tclsh "$0"

# Intellectual property information START
#
# Copyright (c) 2025 Ivan Bityutskiy
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
# Requires package 'makepass':
# https://chiselapp.com/user/ivanb/repository/backup/doc/trunk/tclmodules/makepass-1.1.2.tm
#
# Description END

# load the package 'makepass'
set tclshrc ~/.tclshrc
if {[package vsatisfies [info tclversion] 9-]} then {
  set tclshrc [file tildeexpand $tclshrc]
}
set tclshrc [file normalize $tclshrc]
if {[file isfile $tclshrc]} then {source $tclshrc}

try {package require makepass} on error {} {
  chan puts stderr "\nUnable to load package \"\u001b\[31mmakepass\u001b\[0m\".\n"
  exit 1
}

# clear screen
proc cls {} {chan puts -nonewline stderr "\u001b\[3J\u001b\[1;1H\u001b\[0J"}

# 127 symbols
proc spass {} {
  chan puts stdout [makepass norm 26][makepass norm 25][makepass norm 25][
    makepass norm 25][makepass norm 26]
}

# artificial delays for better security
proc printpass {} {
  variable cvar
  cls
  chan puts stdout {}
  spass
  while {[incr i] ^ 27} {
    after 1200
    spass
  }
  chan puts stdout {}
  after 1200 {set cvar 1}
}

proc startevent {} {
  printpass
  vwait cvar
}

# BEGINNING OF SCRIPT
startevent
# END OF SCRIPT

