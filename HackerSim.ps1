# HackerSim_Hex.ps1
# Emulates a 90s hacker movie terminal using HEX gibberish

function Set-HackerTheme {
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
}

$fakeCommands = @(
    "Accessing mainframe...",
    "Bypassing firewall...",
    "Cracking SHA-512 encryption...",
    "Establishing uplink to satellite...",
    "Launching packet sniffer...",
    "Decrypting password hash...",
    "Injecting trojan protocol...",
    "Compiling kernel exploit...",
    "Spoofing MAC address...",
    "Scanning ports: 21, 22, 80, 443...",
    "Exploiting buffer overflow...",
    "Downloading classified data...",
    "Brute forcing admin password...",
    "Pinging NASA.gov...",
    "Uploading payload to secure node...",
    "Initializing deep scan...",
    "Mapping internal network...",
    "Access granted. Welcome, Agent Neo."
)

$asciiArt = @"
  ____  ____   ___   ____  ____  
 / ___||  _ \ / _ \ / ___||  _ \ 
 \___ \| | | | | | | |    | |_) |
  ___) | |_| | |_| | |___ |  __/ 
 |____/|____/ \___/ \____||_|    

"@

# Generate random hexadecimal gibberish
function Show-Gibberish {
    $hexChars = @("0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F")
    for ($i = 0; $i -lt 20; $i++) {
        $line = ""
        $lineLength = Get-Random -Minimum 40 -Maximum 100  # Random line length

        for ($j = 0; $j -lt $lineLength; $j++) {
            $randomIndex = Get-Random -Minimum 0 -Maximum $hexChars.Count
            $line += $hexChars[$randomIndex]
        }

        Write-Host $line -ForegroundColor Green
        Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 80)
    }
}



function Run-HackerSimulation {
    Set-HackerTheme
    Write-Host $asciiArt -ForegroundColor Green
    Start-Sleep -Milliseconds 700

    foreach ($cmd in $fakeCommands) {
        Write-Host ">> $cmd"
        Show-Gibberish
        Start-Sleep -Milliseconds (Get-Random -Minimum 300 -Maximum 700)
    }

    Write-Host "`n[+] Operation Complete. System compromised." -ForegroundColor Green
    Start-Sleep -Seconds 5
}

Run-HackerSimulation
