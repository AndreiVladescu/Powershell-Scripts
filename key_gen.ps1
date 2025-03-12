# Generate RSA key pair
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider(2048)
$publicKey = $rsa.ToXmlString($false) # Public key
$privateKey = $rsa.ToXmlString($true) # Private key

# Save keys to files (securely)
$publicKey | Out-File publicKey.xml
$privateKey | ConvertTo-SecureString -AsPlainText -Force | Out-File privateKey.enc