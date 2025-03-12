Write-Host "=== SYSTEM INFORMATION ===" -ForegroundColor Cyan
Get-ComputerInfo | Select-Object CsName, OsName, WindowsVersion, WindowsBuildLabEx, OsArchitecture, CsManufacturer, CsModel

Write-Host "`n=== LOGGED-IN USERS ===" -ForegroundColor Cyan
Get-WMIObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName

Write-Host "`n=== ALL LOCAL USERS ===" -ForegroundColor Cyan
Get-LocalUser | Select-Object Name, Enabled

Write-Host "`n=== NETWORK ADAPTERS & IP ADDRESSES ===" -ForegroundColor Cyan
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress

Write-Host "=== PUBLIC IP ADDRESS ===" -ForegroundColor Cyan
$publicIP = (Invoke-WebRequest -Uri "https://api64.ipify.org" -UseBasicParsing).Content
Write-Host "Public IP: $publicIP"