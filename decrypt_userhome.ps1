# Decryption Script (Decrypt-TestingFolder.ps1)

# Load private key
$secureString = Get-Content privateKey.enc | ConvertFrom-SecureString
$privateKey = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsa.FromXmlString($privateKey)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($privateKey)

# Testing folder path
$userDesktop = [Environment]::GetFolderPath("Desktop")
$testingFolder = Join-Path $userDesktop "TESTING"

# Ensure testing folder exists
if (-not (Test-Path $testingFolder -PathType Container)) {
    Write-Error "Testing folder not found: $testingFolder"
    return
}

# Recursive function to decrypt files
function Decrypt-Files($directory) {
    Get-ChildItem -Path $directory -Recurse -File -Filter "*.enc" | ForEach-Object {
        try {
            $filePath = $_.FullName
            $encryptedContent = [System.IO.File]::ReadAllBytes($filePath)

            # Extract encrypted AES key, IV, and data
            $encryptedAesKey = $encryptedContent[0..255]
            $encryptedAesIv = $encryptedContent[256..511]
            $encryptedData = $encryptedContent[512..($encryptedContent.Length - 1)]

            # Decrypt AES key and IV
            $aesKey = $rsa.Decrypt($encryptedAesKey, $false)
            $aesIv = $rsa.Decrypt($encryptedAesIv, $false)

            # Decrypt data
            $aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
            $aes.Key = $aesKey
            $aes.IV = $aesIv

            $decryptor = $aes.CreateDecryptor()
            $decryptedBytes = $decryptor.TransformFinalBlock($encryptedData, 0, $encryptedData.Length)

            $originalName = $_.Name.Replace(".enc", "")
            $originalPath = Join-Path $_.DirectoryName $originalName

            [System.IO.File]::WriteAllBytes($originalPath, $decryptedBytes)
            Remove-Item $filePath
            Write-Host "Decrypted: $originalPath"
        }
        catch {
            Write-Warning "Failed to decrypt: $($_.FullName) - $_"
        }
    }
    Get-ChildItem -Path $directory -Recurse -Directory | ForEach-Object {
        Decrypt-Files $_.FullName
    }
}

# Start decryption
Decrypt-Files $testingFolder
Write-Host "Decryption complete."