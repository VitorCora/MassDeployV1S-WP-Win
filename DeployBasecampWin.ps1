# Force PowerShell to use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define the URL from which to download the program
$url = "https://<YOURCOMPANY>.s3.amazonaws.com/TMServerAgent_Windows.zip"

# Define the path where the program will be downloaded
$downloadPath = "$env:TEMP\TMServerAgent_Windows.zip"

# Create a WebClient object
$webClient = New-Object System.Net.WebClient

# Download the program using the DownloadFile method (compatible with PowerShell v1)
$webClient.DownloadFile($url, $downloadPath)

# Check if the file was downloaded successfully
if (Test-Path $downloadPath) {
    Write-Host "Program downloaded successfully."
    Write-Host "Running the program..."

    # Extract the downloaded file using Shell.Application (compatible with PowerShell v1)
    $shell = New-Object -ComObject Shell.Application
    
    # Define the destination folder path
    $destinationFolderPath = "$env:TEMP\TMServerAgent"
    
    # Create the destination folder if it doesn't exist
    if (-not (Test-Path $destinationFolderPath)) {
        New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
    }
    
    # Get the zip folder and destination folder objects
    $zipFolder = $shell.NameSpace($downloadPath)
    $destinationFolder = $shell.NameSpace($destinationFolderPath)
    
    # Check if the destination folder object is not null
    if ($destinationFolder -ne $null) {
        # Copy the items from the zip folder to the destination folder
        $destinationFolder.CopyHere($zipFolder.Items(), 16)

        # Replace 'EndpointBasecamp.exe' with the actual name of the executable you want to run from the extracted files
        $programPath = "$env:TEMP\TMServerAgent\EndpointBasecamp.exe"
        
        # Check if the program exists in the destination folder
        if (Test-Path $programPath) {
            Write-Host "Running the program located at: $programPath"
            Start-Process -FilePath $programPath
        } else {
            Write-Host "Error: Program not found at $programPath"
        }
    } else {
        Write-Host "Error: Destination folder not accessible."
    }
} else {
    Write-Host "Error: Failed to download the program from $url"
}
