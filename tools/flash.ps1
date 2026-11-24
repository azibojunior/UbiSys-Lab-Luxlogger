<#
.SYNOPSIS
  Programs the PIC24F Starter Kit with the MPLAB command-line debugger (MDB)
  and verifies the result by reading the chip back.

.DESCRIPTION
  Background: with the PIC24F Starter Kit, MPLAB X once reported
  "Programming completed" although the chip still contained the old program.
  This script programs the hex file, reads the whole flash back and compares
  every byte of the hex file with the chip. It only reports success if all
  bytes match.

  Windows only. Build the project first (MPLAB X or make).

.PARAMETER Hex
  Hex file to program. Default: the production hex of this project.

.PARAMETER ReadbackFile
  Only compare Hex with an existing readback file (no programming).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File tools\flash.ps1
#>
param(
    [string]$Hex = "",
    [string]$ReadbackFile = "",
    [string]$Device = "PIC24FJ256GB106",
    [string]$Tool = "skdepic24f1"
)

$ErrorActionPreference = "Stop"
$work = $null
$projectDir = Split-Path -Parent $PSScriptRoot

if ($Hex -eq "") {
    $name = Split-Path -Leaf $projectDir
    $Hex = Join-Path $projectDir "dist\default\production\$name.production.hex"
}
if (-not (Test-Path $Hex)) { throw "Hex file not found: $Hex (build the project first)" }

# Reads an Intel HEX file into a byte array (unused bytes = 0xFF) and returns
# the array plus the list of addresses that the file actually defines.
function Read-IntelHex([string]$path) {
    $data = New-Object byte[] (0x60000)
    for ($i = 0; $i -lt $data.Length; $i++) { $data[$i] = 0xFF }
    $defined = New-Object System.Collections.Generic.List[int]
    $base = 0
    foreach ($line in [System.IO.File]::ReadAllLines($path)) {
        if (-not $line.StartsWith(':')) { continue }
        $count = [Convert]::ToInt32($line.Substring(1, 2), 16)
        $addr  = [Convert]::ToInt32($line.Substring(3, 4), 16)
        $type  = [Convert]::ToInt32($line.Substring(7, 2), 16)
        if ($type -eq 4) {
            $base = [Convert]::ToInt32($line.Substring(9, 4), 16) * 65536
        } elseif ($type -eq 0) {
            for ($i = 0; $i -lt $count; $i++) {
                $a = $base + $addr + $i
                if ($a -lt $data.Length) {
                    $data[$a] = [Convert]::ToByte($line.Substring(9 + 2 * $i, 2), 16)
                    $defined.Add($a)
                }
            }
        }
    }
    return @{ Data = $data; Defined = $defined }
}

function Compare-Hex([string]$expectedPath, [string]$actualPath) {
    $expected = Read-IntelHex $expectedPath
    $actual   = Read-IntelHex $actualPath
    $bad = 0
    $firstBad = -1
    foreach ($a in $expected.Defined) {
        if ($expected.Data[$a] -ne $actual.Data[$a]) {
            $bad++
            if ($firstBad -lt 0) { $firstBad = $a }
        }
    }
    return @{ Total = $expected.Defined.Count; Bad = $bad; FirstBad = $firstBad }
}

if ($ReadbackFile -eq "") {
    $mplab = Get-ChildItem "C:\Program Files\Microchip\MPLABX" -Directory -ErrorAction SilentlyContinue |
             Sort-Object Name -Descending | Select-Object -First 1
    if ($null -eq $mplab) { throw "MPLAB X not found under C:\Program Files\Microchip\MPLABX" }
    $mdb = Join-Path $mplab.FullName "mplab_platform\bin\mdb.bat"

    $work = Join-Path ([System.IO.Path]::GetTempPath()) ("pic24flash_" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $work | Out-Null
    Copy-Item $Hex (Join-Path $work "app.hex")
    # MDB's "dump" only accepts a file name relative to its working directory.
    @("device $Device", "hwtool $Tool -p", "program app.hex", "upload", "dump -pc readback.hex", "quit") |
        Set-Content (Join-Path $work "commands.txt") -Encoding ascii

    Write-Host "Programming $Hex ..."
    Push-Location $work
    try {
        $output = & cmd /c "`"$mdb`" commands.txt 2>&1"
    } finally {
        Pop-Location
    }
    $important = $output | Where-Object { $_ -match 'Program succeeded|Programming|failed|Failed|error|Error|not found|No tool|Upload succeeded|Saved memory' -and $_ -notmatch 'chronicle|Could not read file|^\s+at ' }
    $important | ForEach-Object { Write-Host "  mdb: $_" }

    if (-not ($output -match 'Program succeeded')) {
        throw "MDB did not report 'Program succeeded'. Is the board connected (debugger USB port)?"
    }
    $ReadbackFile = Join-Path $work "readback.hex"
    if (-not (Test-Path $ReadbackFile)) { throw "Readback failed: $ReadbackFile was not created" }
}

$result = Compare-Hex $Hex $ReadbackFile
if ($result.Bad -eq 0) {
    Write-Host ("VERIFY OK: all {0} bytes of the hex file are on the chip." -f $result.Total) -ForegroundColor Green
    if ($work) { Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue }   # keep it only on failure
    exit 0
} else {
    Write-Host ("VERIFY FAILED: {0} of {1} bytes differ (first at hex byte address 0x{2:X})." -f $result.Bad, $result.Total, $result.FirstBad) -ForegroundColor Red
    exit 1
}
