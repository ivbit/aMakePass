

<# Intellectual property information START

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

Intellectual property information END #>

<# Description START

The script creates text file aPasswdsMore.txt
with 100 passwords of user defined length.
If invalid length is specified (>128 or <1),
the value 30 is used.

Description END #>

# BEGINNING OF SCRIPT
# Creating text file with BOMless UTF-8
[CmdletBinding()]
param (
  [ValidateNotNullOrEmpty()]
  [ValidateRange(1, 128)]
  [Byte] $passLength
)

$ErrorActionPreference = "Stop"

try {
  Add-Type -AssemblyName "System.Web"
  if (-not $passLength) {
    $passLength = Read-Host "`nEnter password's length (1-128)"
  }
} catch {
  $passLength = 30
} finally {
  $passTxt = "$PSScriptRoot\aPasswdsMore.txt"
  $passwd = foreach ($count in 1..100) {
    [System.Web.Security.Membership]::GeneratePassword($passLength, 1)
  }
  # PowerShell's commandlets will create UTF-8 with BOM
  # Have to use .Net object to make BOMless UTF-8 file
  [System.IO.File]::WriteAllLines($passTxt, $passwd)
}

# END OF SCRIPT

