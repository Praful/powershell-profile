#=============================================================================
# File: Microsoft.PowerShell_profile.ps1
# Description: Run when new PowerShell started
# Author: Praful https://github.com/Praful/powershell-profile
# Licence: GPL v3
# Requires:
# - PsFzf module
# 
# This file is stored in the PowerShell home folder, which is usually $USERPROFILE\PowerShell
# To reload the profile, run after saving changes:
#
#   & $profile
# or .$profile
#
#
#
# To debug:
#   Set-PSDebug -Strict
#
#=============================================================================




# Set aliases
# ===============================================================

function dirall {get-childitem -force $args|less}
Set-Alias d dirall
function dirpage {get-childitem -force $args|less}
Set-Alias dp dirpage 

function dirdate {get-childitem -force $args | sort -Property lastWriteTime}
Set-Alias dd dirdate

function up-dir3 {cd ..\..\..}
Set-Alias uuu up-dir3

function up-dir2 {cd ..\..}
Set-Alias uu up-dir2

function up-dir1 {cd ..}
Set-Alias u up-dir1

Set-Alias ga get-alias

function cdd {cd}

function cddata {Set-Location c:\data}
Set-Alias cdd cddata

function cdrubyproject {Set-Location c:\data\ruby\projects}
Set-Alias cdr cdrubyproject

function cdlinux {Set-Location c:\data\LinuxHome}
Set-Alias cdx cdlinux

function cdlogs {Set-Location c:\data\logs}
Set-Alias cdl cdlogs

function cdscripts {Set-Location c:\data\scripts}
Set-Alias cds cdscripts

function cdsettings {Set-Location c:\data\settings}
Set-Alias cdt cdsettings

function cdapps {Set-Location c:\apps}
Set-Alias cda cdapps

function cdhome {Set-Location %USERPROFILE%}
Set-Alias cdh cdhome

function cddevopensource {Set-Location c:\data\dev\open-source}
Set-Alias cdo cddevopensource

function cddevproject {Set-Location c:\data\dev\projects}
Set-Alias cdp cddevproject

function cddevgithub {Set-Location c:\data\dev\github\}
Set-Alias cdg cddevgithub 

function edit {pkedit64 $args}
Set-Alias e edit

function code {code.exe -r $args}
Set-Alias c code

function runprofile {. $profile}
Set-Alias pp runprofile

function editprofile {e $profile}
Set-Alias ep editprofile

function cmdc {cmd /c $args}
Set-Alias cc cmdc

function explorer {explorer.exe .}
Set-Alias ex explorer 

# For typing out a file - not needed with PS 5
# function lesscmd {less $args}
# Set-Alias t lesscmd
Set-Alias t less
# For piping output to less
Set-Alias l less

function convert-unix2dos {
  Get-ChildItem * -Include $args | ForEach-Object {
      ## If contains UNIX line endings, replace with Windows line endings
      if (Get-Content $_.FullName -Delimiter "`0" | Select-String "[^`r]`n")
      {
          $content = Get-Content $_.FullName
          $content | Set-Content $_.FullName
      }
  }
}
# Example usage: from dir with unix file endings: unix2dos *.js
Set-Alias unix2dos convert-unix2dos

function env-one {get-childitem env:$args | format-list |less}
Set-Alias env env-one

$ver=$PSVersionTable

Set-Alias which get-command

# Stop output from being truncated (for those cmds tha use format-table
# $PSDefaultParameterValues = @{"Format-Table:Autosize"=$true}

# Can do <command> | grep
# eg alias | grep drive
function grep {
  $input | out-string -stream | select-string $args
}
function prompt
{
  $loc = Get-Location

  # Emulate standard PS prompt with location followed by ">"
  # $out = "PS $loc> "
  
  # Or prettify the prompt by coloring its parts
  # Write-Host -NoNewline -ForegroundColor Cyan "PS "
  # Write-Host -NoNewline -ForegroundColor Yellow $loc
  Write-Host -BackgroundColor green -ForegroundColor Black $loc
  $out = "> "

  # Check for ConEmu existance and ANSI emulation enabled
  if ($env:ConEmuANSI -eq "ON") {
    # Let ConEmu know when the prompt ends, to select typed
    # command properly with "Shift+Home", to change cursor
    # position in the prompt by simple mouse click, etc.
    $out += "$([char]27)]9;12$([char]7)"

    # And current working directory (FileSystem)
    # ConEmu may show full path or just current folder name
    # in the Tab label (check Tab templates)
    # Also this knowledge is crucial to process hyperlinks clicks
    # on files in the output from compilers and source control
    # systems (git, hg, ...)
    if ($loc.Provider.Name -eq "FileSystem") {
      $out += "$([char]27)]9;9;`"$($loc.Path)`"$([char]7)"
    }
  }

  return $out
}
# Imports
# ===============================================================
# if ($host.Name -eq 'ConsoleHost')
# {
# Import-Module PSReadline
# }
Set-PSReadlineOption -EditMode Vi

# FZF
# For commands, see https://github.com/kelleyma49/PSFzf
# Summary: 
#   se (Search-Everything) = use Everything, fe = edit, fd = cd, fz = use ZLocation history,
#   fh = use fzf history, cde = cd using Everything
#
#   se -ext cpp,h -FilePattern Bytes | Get-Item
#
#   Ctrl-T = select item, Ctrl-R use PSReadline command history,
#   Alt-C = cd, Alt-A = PSReadline argument history
# ===============================================================

# . "c:\data\scripts\Invoke-Parallel.ps1"

Remove-PSReadlineKeyHandler -chord Ctrl+r -vimode command
Remove-PSReadlineKeyHandler -chord Ctrl+t -vimode insert
Import-Module PSFzf -ArgumentList 'Ctrl+t','Ctrl+r'
# Import-Module PSFzf 

# Import-Module posh-git
# Import-Module oh-my-posh
# $ThemeSettings.MyThemesLocation='C:\data\WindowsPowerShell'
# Set-Theme PK

# ===============================================================
# ===============================================================
# ===============================================================
# ===============================================================
# ===============================================================
# ===============================================================
