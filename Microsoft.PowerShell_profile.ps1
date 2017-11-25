. $PSScriptRoot\config.ps1
Import-Module posh-git

# Load Scripts

function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}


# Set Prompt
function prompt{
    $loc =  (get-item -path .\).fullname
    
    # Display Admin if running as Admin
    
    if(get-gitdirectory){
        $gitStatus = Get-Location | Get-Item | Get-Gitstatus
        $gitBranch = $gitStatus.Branch
        $gitUpstream = $gitStatus.Upstream
        $gitAhead = $gitStatus.Aheadby
        $gitBehind = $gitStatus.Behindby
        $gitWorking = $gitStatus.Working
        $gitIndex = $gitStatus.Index
        $primaryColor = "gray"


        write-host "[|/]: $gitBranch " -ForegroundColor $primaryColor -NoNewline
        if($gitUpstream -ne $null){
            write-host "[^]: $gitUpstream " -ForegroundColor $primaryColor -NoNewline
        }

        $AllStatus = @()

        if($gitStatus.hasWorking -eq $True){
            $workingProp = @{total=$($gitWorking.length);color="DarkRed";symbol="?";name="Unstaged:"}
            $Working = new-object -TypeName PSObject -Property $workingProp
            $Allstatus += $Working
        }

        if($gitStatus.hasIndex -eq $True){
            $indexProp = @{total=$($gitIndex.length);color="DarkGreen";symbol="!";name="Staged:"}
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
                write-host " $($curitem.symbol) $($curitem.name) $($curitem.total) " -ForegroundColor $curitem.color -nonewline
            }
        }
        write-host ""
    } 
    if(Test-IsAdmin){
        Write-Host "[A]" -NoNewline -BackgroundColor Black -ForegroundColor red
    }
    Write-Host "$loc" -ForegroundColor DarkGray
    Write-Host ">" -ForegroundColor Cyan -NoNewline
    Write-Host ">" -ForegroundColor Green -NoNewline
    Write-Host ">" -ForegroundColor Yellow -NoNewline
    Write-Host ">" -ForegroundColor Red -NoNewline

    Return " "
}
