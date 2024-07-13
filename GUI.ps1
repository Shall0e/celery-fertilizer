$localAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::localApplicationData)
$roamingAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ErrorActionPreference= 'silentlycontinue'
$ProgressPreference = 'silentlycontinue'

$host.UI.RawUI.WindowTitle = "betterCelery - v1.0.1"

Add-Type -TypeDefinition @'
    using System;
    using System.Runtime.InteropServices;
    public class PInvoke {
        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern IntPtr GetStdHandle(int nStdHandle);
        [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
        [DllImport("kernel32.dll", CharSet=CharSet.Auto, SetLastError=true)]
        public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Auto)]
        public struct COORD {
            public short X;
            public short Y;
            public COORD(short x, short y) {
                X = x;
                Y = y;
            }
        }
        [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Auto)]
        public struct CONSOLE_FONT_INFO_EX {
            public int cbSize;
            public uint nFont;
            public COORD dwFontSize;
            public int FontFamily;
            public int FontWeight;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst=0x20)]
            public string FaceName;
        }
    }
'@

function betterPause {
    param (
        [string]$Message
    )

    if ($Message) {
        Write-Host -ForegroundColor Red $Message
    }
    Write-Host ' '
    Write-Host -ForegroundColor Magenta "(Press Enter to go back)" -NoNewline
    $null = Read-Host
}

function Set-ConsoleFontSize {
    param (
        [int]$FontSize
    )
    $StdOutHandle = [PInvoke]::GetStdHandle(-11)
    $ConsoleFontInfo = New-Object PInvoke+CONSOLE_FONT_INFO_EX
    $ConsoleFontInfo.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($ConsoleFontInfo)
    $ConsoleFontInfo.dwFontSize = New-Object PInvoke+COORD -ArgumentList 0, $FontSize
    [PInvoke]::SetCurrentConsoleFontEx($StdOutHandle, $false, [ref]$ConsoleFontInfo)
}

$width = 100
$height = 40

$bufferSize = New-Object System.Management.Automation.Host.Size($width, 3000)  # Adjust 3000 as needed
$host.ui.rawui.BufferSize = $bufferSize

$windowSize = New-Object System.Management.Automation.Host.Size($width, $height)
$host.ui.rawui.WindowSize = $windowSize

Set-ConsoleFontSize -FontSize 20

Clear-Host

function neofetch {
    Clear-Host
    Write-HostCenter -ForegroundColor 'Green' -Message '                                            |||||||||                                         '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                          _||||  ||||||   |||||                               '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                         ||||^      |||||||||||||                             '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                    ||||||||       >||||||   |||||                            '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                    ||||}||   |||||||||>      ||||                            '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                   ||||     |||||||||    ||   ||||                            '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                   ||||     ||||        ||||  ||||                            '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                    |||     >|||        |||  ||||                             '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                 |||||||   |||||     ||||||  |||||||                          '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                |||      |||||||     ||||||^    |||||                         '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                |||     ||||          ||||||||    ||||||                      '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                |||     ||||         ||||  ||    ^||||||||                    '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                ||||    ||||    ||||||||         ||||> |||                    '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                 ||||   ||||     |||||||_       ||||   ||||_                  '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                  |||    |||      |||||||||    ||||    ||||||||||||           '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                  ||||   |||     ||||    ^     ||||        >|||||||||         '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                  ||||   ||||   |||          |||||  |             ||||        '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                  ||||  >|||    ||       |||||||   |||>|||||||    ||||        '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                 ||||   ||||        ||||||||||   |||||||||||    |||||         '
    Write-HostCenter -ForegroundColor 'Green' -Message '                                ||||   ||||      ||||||||||||||||||||||       ||||||          '
    Write-HostCenter -ForegroundColor 'Green' -Message '                               ||||  ;||||     ||||||  ^ ||||||>    ||||   |||||||            '
    Write-HostCenter -ForegroundColor 'Green' -Message '                             ||||_  |||||   ||||||^   |||||||||^          |||||               '
    Write-HostCenter -ForegroundColor 'Green' -Message '                           _|||}   ||||    |||||       |     |||           |||                '
    Write-HostCenter -ForegroundColor 'Green' -Message '                          ||||   }||||  |||||^                    ||||||  ||||                '
    Write-HostCenter -ForegroundColor 'Green' -Message '                       |||||    }|||   ||||}        ||||          |||||||||||^                '
    Write-HostCenter -ForegroundColor 'Green' -Message '                     |||||    }|||;  ||||^     |||||||||||||     ||||                         '
    Write-HostCenter -ForegroundColor 'Green' -Message '                   ||||}    |||}_  _||||    ||||||||_   ||||||| ||||                          '
    Write-HostCenter -ForegroundColor 'Green' -Message '                }|||||    |||||  |||||    _||||_           |||||||||                          '
    Write-HostCenter -ForegroundColor 'Green' -Message '              ;||||_    ||||   >|||>    |||||                 |}|>                            '
    Write-HostCenter -ForegroundColor 'Green' -Message '             ||||;    ||||}   ||||     ||||                                                   '
    Write-HostCenter -ForegroundColor 'Green' -Message '            }||_   _}|||    |||_     ||||                                                     '
    Write-HostCenter -ForegroundColor 'Green' -Message '           _||_     }}    ||||^     |||_                                                      '
    Write-HostCenter -ForegroundColor 'Green' -Message '           |||          ;||||     |||}^                                                       '
    Write-HostCenter -ForegroundColor 'Green' -Message '           |||            }     _||||                                                         '
    Write-HostCenter -ForegroundColor 'Green' -Message '           |||                |||||                                                           '
    Write-HostCenter -ForegroundColor 'Green' -Message '            ||||            |||||^                                                            '
    Write-HostCenter -ForegroundColor 'Green' -Message '             _|||}      ||||||}                                                               '
    Write-HostCenter -ForegroundColor 'Green' -Message '               ^|||||||||||}                                                                  '
    
    Write-Host ' '

    $neoversion = (Invoke-WebRequest -Uri 'https://api.github.com/repos/sten-code/Celery/releases/latest' | ConvertFrom-Json).tag_name
    Write-HostCenter -ForegroundColor 'White' -Message "latest Celery version: v$neoversion"
    Write-HostCenter -ForegroundColor 'White' -Message "latest Fertiziler version: v1.0.0"
    Write-Host ' '
    $neoversion = (Invoke-WebRequest -UserAgent "WEAO-3PService" -Method Get -Uri 'https://weao.xyz/api/versions/current' | ConvertFrom-Json).WindowsDate
    Write-HostCenter -ForegroundColor 'White' -Message "last Roblox update: $neoversion"
    $neoversion = (Invoke-WebRequest -UserAgent "WEAO-3PService" -Method Get -Uri 'https://weao.xyz/api/versions/current' | ConvertFrom-Json).Windows
    Write-HostCenter -ForegroundColor 'White' -Message "newest Roblox version: $neoversion"
    Write-Host ' '
    Write-HostCenter -ForegroundColor 'Cyan' -Message "Credits:"
    Write-HostCenter -ForegroundColor 'Cyan' -Message "sten-code, stiiizzycat  :  Celery UI V2 & Website"
    Write-HostCenter -ForegroundColor 'Cyan' -Message "Celery Developers, Woody/Jay  :  Celery API"
    Write-HostCenter -ForegroundColor 'Cyan' -Message "shall0e  :  Me, creator of Fertiziler"
    Write-HostCenter -ForegroundColor 'Cyan' -Message "WEAO.xyz Team  :  WEAO API"
    Write-Host ' '
    Write-HostCenter -ForegroundColor 'Blue' -Message "https://discord.gg/celery"
    Write-Host ' '
    betterPause
}

function Write-HostCenter { param([string]$Message,[string]$ForegroundColor="White") Write-Host -ForegroundColor $ForegroundColor ("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($Message.Length / 2)))), $Message) }

for (;;) {
if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
    Write-HostCenter -Message 'Celery is installed!' -ForegroundColor "Green"
} else {
    Write-HostCenter -Message 'Celery is not installed.' -ForegroundColor "Red"
    Write-HostCenter -Message 'It is recommended to turn off your Antivirus before installing.'
}
Write-Host ' '
Write-Host 'Installation' -ForegroundColor Blue
Write-Host '| [1] - Install Celery'
Write-Host '| [2] - Repair Celery'  -ForegroundColor Cyan 
Write-Host '| [3] - Uninstall Celery'
Write-Host '| [4] - Reinstall + Repair'  -ForegroundColor Cyan 
Write-Host ' '
Write-Host 'Utility / Launching' -ForegroundColor Blue
Write-Host '| [5] - Open Celery' -ForegroundColor Cyan 
Write-Host '| [6] - Open Installation Folder'
Write-Host '| [7] - Open Themes Folder'
Write-Host '| [8] - Open Scripts Folder'
Write-Host ' '
Write-Host 'Information' -ForegroundColor Blue
Write-Host '| [9] - Neofetch Display Info'
Write-Host '| [10] - Open Celery Site'
Write-Host ' '
Write-Host 'Fixing Tool' -ForegroundColor Blue
Write-Host '| [0] - Start Fixer Tool'
Write-Host ' '

Write-Host -ForegroundColor Magenta "> " -NoNewline
$hostInput = Read-Host
if ($hostInput -eq "0") {
    betterPause -Message "Still being worked on, check back later!"
} elseif ($hostInput -eq "1") {
    if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
        Clear-Host
        betterPause -Message "Error: Celery is already installed, did you mean to repair?"
    } else {
        powershell.exe -File (Join-Path $scriptDir "Options\install.ps1")
    }
} elseif ($hostInput -eq "2") {
    if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
        powershell.exe -File (Join-Path $scriptDir "Options\repair.ps1")
    } else {
        Clear-Host
        betterPause -Message "Error: Celery is not installed, did you mean to install it?"
    }
} elseif ($hostInput -eq "3") {
    if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
        powershell.exe -File (Join-Path $scriptDir "Options\uninstall.ps1")
    } else {
        Clear-Host
        betterPause -Message "Error: Celery is not installed, did you mean to install it?"
    }
} elseif ($hostInput -eq "4") {
    if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
        powershell.exe -File (Join-Path $scriptDir "Options\advrepair.ps1")
    } else {
        Clear-Host
        betterPause -Message "Error: Celery is not installed, did you mean to install it?"
    }
} elseif ($hostInput -eq "5") {
    if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
        Start-Process -FilePath (Join-Path $localAppData "Celery\Celery.exe")
    } else {
        Clear-Host
        betterPause -Message "Error: Celery is not installed, did you mean to install it?"
    }
} elseif ($hostInput -eq "6") {
    if (Test-Path (Join-Path $localAppData "Celery") -PathType Container) {
        cmd.exe /c "start %localappdata%/Celery"
    } else {
        Clear-Host
        betterPause -Message "Error: Celery is not installed."
    }
} elseif ($hostInput -eq "7") {
    if (Test-Path (Join-Path $roamingAppData "Celery/Themes") -PathType Container) {
        cmd.exe /c "start %appdata%/Celery/Themes"
    } else {
        Clear-Host
        betterPause -Message "Error: folder does not exist. Celery may either be installed or you haven't ran it yet."
    }
} elseif ($hostInput -eq "8") {
    if (Test-Path (Join-Path $localAppData "Celery\scripts") -PathType Container) {
        cmd.exe /c "start %localappdata%/Celery/scripts"
    } else {
        Clear-Host
        betterPause -Message "Error: folder does not exist. Celery may either be installed or you haven't ran it yet."
    }
} elseif ($hostInput -eq "9") {
    neofetch
} elseif ($hostInput -eq "10") {
    Start-Process "https://celery.zip/"
} else {
    Clear-Host
    betterPause -Message "Error: Not a valid selection."
}
Clear-Host
}