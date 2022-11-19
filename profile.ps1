#=============================================================================
# File: profile.ps1
# File: Was Microsoft.PowerShell_profile.ps1
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
# To update powershell from command line (https://www.thomasmaurer.ch/2019/07/how-to-install-and-update-powershell-7/):
#   iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
#
#
# The following modules are assumed to be installed:
#   oh-my-posh-core
#   PSFzf
#   WslInterop
#
#=============================================================================

Set-StrictMode -Version latest

# Set-PSDebug -Strict


# Set aliases
# ===============================================================
# function Test-Administrator {  
#
  # $user = [Security.Principal.WindowsIdentity]::GetCurrent();
  # (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
# }


function d {get-childitem -force $args|less}
# Set-Alias d dirall
function dp {get-childitem -force $args|less}
# Set-Alias dp dirpage 

function dd {get-childitem -force $args | sort -Property lastWriteTime}
# Set-Alias dd dirdate

function uuu {cd ..\..\..}
# Set-Alias uuu up-dir3

function uu {cd ..\..}
# Set-Alias uu up-dir2

function u {cd ..}
# Set-Alias u up-dir1

Set-Alias ga get-alias

function cdd {cd}

function cdd {Set-Location $env:DATA}
# Set-Alias cdd cddata

function cdr {Set-Location $env:DATA\ruby\projects}
# Set-Alias cdr cdrubyproject

function cdv {Set-Location $env:DATA\LinuxHome\vimfiles}
# Set-Alias cdv cdvim

function cdx {Set-Location $env:DATA\LinuxHome}
# Set-Alias cdx cdlinux

function cdl {Set-Location $env:DATA\logs}
# Set-Alias cdl cdlogs

function cds {Set-Location $env:DATA\scripts}
# Set-Alias cds cdscripts

function cdt {Set-Location $env:DATA\settings}
# Set-Alias cdt cdsettings

function cdv {Set-Location $env:DATA\vim\src\latest}
# Set-Alias cdv cdvim

function cda {Set-Location $env:APPS}
# Set-Alias cda cdapps

function cdh {Set-Location $env:USERPROFILE}
# Set-Alias cdh cdhome

function cdo {Set-Location $env:DATA\dev\open-source}
# Set-Alias cdo cddevopensource

function cdp {Set-Location $env:DATA\dev\projects}
# Set-Alias cdp cddevproject

function cdg {Set-Location $env:DATA\dev\github\}
# Set-Alias cdg cddevgithub 

function cdw {Set-Location $env:DATA\downloads}
# Set-Alias cdw cddownload 

function edit {pkedit $args}
Set-Alias e edit

function code {code.exe -r $args}
Set-Alias c code

function pp {. $profile.CurrentUserAllHosts}
# Set-Alias pp runprofile

function ep {e $profile.CurrentUserAllHosts}
# Set-Alias ep editprofile

function cc {cmd /c $args}
# Set-Alias cc cmdc

function jl {jupyter lab}
# Set-Alias jl jupyterlab

function jn {jupyter notebook}
# Set-Alias jn jupyternotebook

Set-Alias ipy ipython
Set-Alias py python

set-alias bcomp $bc

function ex {explorer.exe $args}

#git aliases
function gitls {git ls-tree --full-tree -r --name-only HEAD}

# This lets you pipe output to vim via a temp file
# eg gci *.ps1 | vi
Function vi {
  # Doesn't work
  # $input | out-string -stream | gvim $args
  #
  # Use temp file instead
  $TempFile = New-TemporaryFile
  # $input | Out-file $TempFile | edit $TempFile |out-null
  $input | Out-file $TempFile 
  start-process -Wait -Filepath gvim -ArgumentList $TempFile
  remove-item $TempFile
}

# Set-Alias powershell pwsh.exe

# For typing out a file - not needed with PS 5
# function lesscmd {less $args}
# Set-Alias t lesscmd
Set-Alias t less
# For piping output to less
Set-Alias l less

Set-Alias ff fzf

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
#
# Example usage: from dir with unix file endings: unix2dos *.js
Set-Alias unix2dos convert-unix2dos

function env-one {get-childitem env:$args | format-list |less}
Set-Alias env env-one

# function ag-search {ag.exe -i $args}
# Set-Alias ag ag-search
# function rg-search {rg.exe -i $args}
# Set-Alias rg rg-search
$ver=$PSVersionTable

Set-Alias which get-command

function start-admin-pwsh { start-process pwsh –verb runAs }
function start-admin-wt {Start-Process "wt.exe" -ArgumentList "-p pwsh" -Verb runas -PassThru}
function start-admin-bc {Start-Process $bc -Verb runas -PassThru}
function start-admin {Start-Process "$args" -Verb runas -PassThru}

# Stop output from being truncated (for those cmds tha use format-table
# $PSDefaultParameterValues = @{"Format-Table:Autosize"=$true}

# Can do <command> | grep
# eg alias | grep drive
function grep {
  $input | out-string -stream | select-string $args
}

# function prompt {

  # $loc = Get-Location

  # # Emulate standard PS prompt with location followed by ">"
  # # $out = "PS $loc> "
  
  # # Or prettify the prompt by coloring its parts
  # # Write-Host -NoNewline -ForegroundColor Cyan "PS "
  # # Write-Host -NoNewline -ForegroundColor Yellow $loc
  # # Write-Host -BackgroundColor green -ForegroundColor Black $loc
  # Write-Host -NoNewLine -BackgroundColor  green -ForegroundColor black $loc
  # Write-Host ""
  # $out=""
  # If (Test-Administrator) {
      # $out += $out + "Admin" 
  # }

  # $out += "> "

  # return $out
# }

# Imports
# ===============================================================
# See https://github.com/mikebattista/PowerShell-WSL-Interop
# remove "less" and use the git version since this script is also used for 
# admin and admin doesn't have any distros installed for wsl.
Import-WslCommand "apt", "awk", "grep", "head", "sed", "seq", "tail", "dos2unix", "du", "df", "wget", "gzip", "cat", "free", "top", "uname", "wc"
$WslDefaultParameterValues= @{}
$WslDefaultParameterValues["less"] = "--no-init --ignore-case --quit-if-one-screen --force --raw-control-chars"
# Temp because there is an issue with ls | less,
# which requires WSL1 to be used. By default, WslInterop uses the default
# distro. I wanted the default to be a WSL2 distro. This switch tells
# WslInterop which distro to use.
$WslDefaultParameterValues["-d"] = "Ubuntu-20.04"
# if ($host.Name -eq 'ConsoleHost')
# {
# Import-Module PSReadline
# }
Set-PSReadlineOption -EditMode Vi
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -Colors @{ Prediction = [ConsoleColor]::DarkGray}

# Set-PSReadLineOption -Prediction
#
# See https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.  It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
Set-PSReadLineKeyHandler -Key Alt+w `
                         -BriefDescription SaveInHistory `
                         -LongDescription "Save current line in history but do not execute" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

# Invoke-Expression (&starship init powershell)

#

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

# . "$env:DATA\scripts\Invoke-Parallel.ps1"

set-PSReadLineOption -Colors @{ InlinePrediction = '#9CCEA3'}

Remove-PSReadlineKeyHandler -chord Ctrl+r -vimode command
Remove-PSReadlineKeyHandler -chord Ctrl+t -vimode insert
Import-Module PSFzf 
# Import-Module PSFzf -ArgumentList 'Ctrl+t','Ctrl+r'
#
# Shows navigable menu of all options when hitting Tab
# psfzf is better
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineKeyHandler -chord Ctrl+o -function {ViForwardChar}

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Enable-PsFzfAliases

oh-my-posh --init --shell pwsh --config $env:DATA\PowerShell\pk-posh-theme.omp.json | Invoke-Expression

# ===============================================================
# ===============================================================
# ===============================================================
# ===============================================================
# ===============================================================
# ===============================================================
