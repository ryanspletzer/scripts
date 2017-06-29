Set-Location -Path "D:\Scripts"
Import-Module -Name posh-git

function Global:Set-MaxWindowSize
{
    
    if ($Host.Name -match "console")
       {
        $MaxHeight = $host.UI.RawUI.MaxPhysicalWindowSize.Height
        $MaxWidth = $host.UI.RawUI.MaxPhysicalWindowSize.Width

        $MyBuffer = $Host.UI.RawUI.BufferSize
        $MyWindow = $Host.UI.RawUI.WindowSize
    
        $MyWindow.Height = ($MaxHeight)
        $MyWindow.Width = ($Maxwidth-2)

        $MyBuffer.Height = (9999)
        $MyBuffer.Width = ($Maxwidth-2)

        $host.UI.RawUI.set_bufferSize($MyBuffer)
        $host.UI.RawUI.set_windowSize($MyWindow)
       }

    $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $CurrentUserPrincipal = New-Object Security.Principal.WindowsPrincipal $CurrentUser
    $Adminrole = [Security.Principal.WindowsBuiltinRole]::Administrator
    If (($CurrentUserPrincipal).IsInRole($AdminRole)){$Elevated = "Administrator"}    
    
    $Title = $Elevated + " $ENV:USERNAME".ToUpper() + ": $($Host.Name) " + $($Host.Version) + " - " + (Get-Date).toshortdatestring() 
    $Host.UI.RawUI.set_WindowTitle($Title)

}

function Enter-ElevatedPSSession {
    #requires -Version 2.0

    <#
    .SYNOPSIS
        Enters a new elevated powershell process.

    .DESCRIPTION
        Enters a new elevated powershell process. You can optionally close your existing session.

    .PARAMETER CloseExisting
        If specified, the existing powershell session will be closed.

    .NOTES
        UAC will prompt you if it is enabled.

        Starts new administrative session.

        Will do nothing if you are already running elevated.

    .EXAMPLE
        # Running as normal user
        C:\Users\Joe> Enter-ElevatedPSSession
        # Starts new PowerShell process / session as administrator, keeping current session open.

    .EXAMPLE
        # Running as normal user
        C:\Users\Joe> Enter-ElevatedPSSession -CloseExisting
        # Starts new PowerShell process / session as administrator, exiting the current session.

    .EXAMPLE
        # Running already as administrator
        C:\Windows\System32> Enter-ElevatedPSSession
        Already running as administrator.
        # Message is written to host.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
                   Position=0)]
        [Alias('c')]
        [switch]
        $CloseExisting
    )
    begin {
        $runningProcess = 'powershell'
        if ((Get-Process -Id $pid).Name -eq 'powershell_ise') {
            $runningProcess = 'powershell_ise'
        }
        $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $Principal = New-Object System.Security.Principal.WindowsPrincipal($Identity)
        $isAdmin = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    process {
        if ($isAdmin) {
            Write-Host -Object "Already running as administrator."
            return
        }
        if ($CloseExisting.IsPresent) {
            Start-Process $runningProcess -Verb RunAs
            exit
        } else {
            Start-Process $runningProcess -Verb RunAs
        }
    }
}

New-Alias -Name su -Value Enter-ElevatedPSSession
