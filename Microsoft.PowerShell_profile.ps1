# Config Script. This is full of PSDrives and other virables or path modifications that make life easy. 
. $PSScriptRoot\config.ps1

# Load Scripts
Write-Host "ɸ Loading Scripts" -ForegroundColor Yellow
Get-ChildItem coding:\Powershell\POSH-Profile\Scripts | Where {$_.Name -notlike "__*" -and $_.Name -like "*.ps1"} | ForEach { 
    . $_.FullName 
    
}
write-host ""
import-module posh-git
$ErrorActionPreference = "Stop"

function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Set Prompt
function prompt {
    Write-Host "PowerShell " -NoNewline -ForegroundColor Cyan
    if(Test-IsAdmin){
        Write-Host "ɸ " -NoNewline -ForegroundColor red
    } else {
        Write-Host "ɸ " -NoNewline -ForegroundColor green
    }
    write-host (Get-Location).path -NoNewline

    write-host " <" -NoNewline

 # Adds Git Folder features
    if(get-gitdirectory){
        write-host " "
        $gitStatus = Get-Location | Get-Item | Get-Gitstatus
        $gitBranch = $gitStatus.Branch
        $gitUpstream = $gitStatus.Upstream
        $gitAhead = $gitStatus.Aheadby
        $gitBehind = $gitStatus.Behindby
        $gitWorking = $gitStatus.Working
        $gitIndex = $gitStatus.Index
        $primaryColor = "darkgray"


        write-host "[BRANCH] " -BackgroundColor $primaryColor -ForegroundColor white -NoNewline
        write-host "$gitBranch | " -BackgroundColor $primaryColor -ForegroundColor White -NoNewline
        if($gitUpstream -ne $null){
            write-host "[UP] $gitUpstream " -BackgroundColor $primaryColor -ForegroundColor White -NoNewline
        }

        $AllStatus = @()

        if($gitStatus.hasWorking -eq $True){
            $workingProp = @{total=$($gitWorking.length);color="DarkRed";symbol="X";name="Unstaged:"}
            $Working = new-object -TypeName PSObject -Property $workingProp
            $Allstatus += $Working
        }

        if($gitStatus.hasIndex -eq $True){
            $indexProp = @{total=$($gitIndex.length);color="DarkGreen";symbol="*";name="Staged:"}
            $Index = new-object -TypeName PSObject -Property $indexProp
            $Allstatus += $Index
        }

        if($gitAhead -gt 0){
            $aheadProp = @{total=$gitAhead;color="DarkGreen";symbol="+";name="Ahead:"}
            $Ahead = new-object -TypeName PSObject -Property $aheadProp
            $Allstatus += $Ahead
        }

        if($gitBehind -gt 0){
            $behindProp = @{total=$gitBehind;color="DarkRed";symbol="-";name="Behind:"}
            $Behind = new-object -TypeName PSObject -Property $behindProp
            $Allstatus += $Behind
        }
        if($allstatus.length -ne 0){
            for($g=0; $g -lt $allstatus.length; $g++){
                $curItem = $allstatus[$g]
                $nextItem = $allstatus[$g + 1]
                $preItem = $allstatus[$g - 1]
                if($g -eq 0){
                    write-host "" -ForegroundColor DarkGray -BackgroundColor $curitem.color -NoNewline
                } else {
                    write-host "" -ForegroundColor $preitem.color -BackgroundColor $curitem.color -NoNewline
                }
                write-host " $($curitem.symbol) $($curitem.name) $($curitem.total) " -BackgroundColor $curitem.color -nonewline
                if($($g+1) -eq $allstatus.length){
                    write-host "" -ForegroundColor $curitem.color -NoNewline
                }
            }
        } else {
            write-host "" -ForegroundColor DarkGray -NoNewline
        }
    } 
    write-host " "
    Return " "
}