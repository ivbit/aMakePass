#!/usr/bin/lua5.3

--[[
Intellectual property information START

Copyright (c) 2020 Ivan Bityutskiy 

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Intellectual property information END
]]

--[[
Description START

lua version of the script
The script creates text file aPasswdsMore.txt
with 100 passwords of user defined length.
If invalid length is specified (>127 or <1),
the value 30 is used.

Description END
]]

-- BEGINNING OF SCRIPT
tabValidChars = {"!", "#", "$", "%", "&", "(", ")", "*", "+", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "]", "^", "_", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}"}

math.randomseed(os.time())

varTemp = io.output()
strPasswdFile = "aPasswdsMore.txt"
io.write("\nEnter password's length (1-127): ")
numPassLength = tonumber(io.read())
if type(numPassLength) ~= "number" or numPassLength <= 0 or numPassLength > 127 then
  numPassLength = 30
end
numPassLength = math.ceil(numPassLength)

io.output(strPasswdFile)

function funMakePass(intFunCounter)
  local strPassword = ""
  for numCounter = 1, intFunCounter do
    strPassword = strPassword .. tabValidChars[math.random(1, #tabValidChars)] 
  end
  return strPassword
end

for numWriteCounter = 1, 100 do
  io.write(funMakePass(numPassLength), "\n")
end

io.output(varTemp)
io.write("\n", strPasswdFile, "\noverwritten successfully!\n\n")

-- END OF SCRIPT

