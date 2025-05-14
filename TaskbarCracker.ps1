# Define the file path for output
$outputFile = "c:\scripts\input.txt"

# Initialize an array to hold output lines
$outputLines = @()

# Function to extract printable ASCII strings from a byte array.
# It collects sequences of printable characters (ASCII code 32–126)
# that are at least $MinLength characters long.
function Get-PrintableStrings {
    param(
        [byte[]]$Data,
        [int]$MinLength = 1
    )
    $sb = New-Object System.Text.StringBuilder
    $strings = @()

    foreach ($b in $Data) {
        if ($b -ge 32 -and $b -le 126) {
            [void]$sb.Append([Char]$b)
        }
        else {
            if ($sb.Length -ge $MinLength) {
                $strings += $sb.ToString()
            }
            $sb.Clear() | Out-Null
        }
    }

    # Capture any trailing string in our builder.
    if ($sb.Length -ge $MinLength) {
        $strings += $sb.ToString()
    }
    return $strings
}

# Set registry path and the value name to look for
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
$valueName = "Favorites"

try {
    $regData = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
    $binaryData = $regData.$valueName
}
catch {
    $outputLines += "Failed to read the registry value: $_"
    $outputLines | Out-File -FilePath $outputFile -Encoding UTF8
    exit
}

if (-not $binaryData) {
    $outputLines += "No binary data found in the registry for pinned taskbar items."
    $outputLines | Out-File -FilePath $outputFile -Encoding UTF8
    exit
}

# Extract printable strings from the binary blob.
$printableStrings = Get-PrintableStrings -Data $binaryData -MinLength 1

# Filter strings that look like file paths (e.g.: starting with "C:\" or similar)
$pinnedFilePaths = $printableStrings | Where-Object { $_ -match "^[A-Za-z]:\\.*" }

$outputLines += "----- Extracted Pinned Taskbar Items -----`n"

if ($pinnedFilePaths) {
    foreach ($item in $pinnedFilePaths) {
        $outputLines += $
        
  
    }
}
else {
    $outputLines += "No file paths were detected among the extracted strings."
    $outputLines += "Here is all the extracted text that might help in manual analysis:`n"
    foreach ($str in $printableStrings) {
        $outputLines += $str
    }
}

$outputLines += "`n----- End of Output -----"

# Write the accumulated output to a file.
$outputLines | Out-File -FilePath $outputFile -Encoding UTF8
Write-Output "Output written to $outputFile"