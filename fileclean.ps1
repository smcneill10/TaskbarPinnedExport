# Specify the paths for the input and output files
$inputFile  = "C:\scripts\input.txt"
$outputFile = "C:\scripts\output.txt"

# Read the entire file as a single string using the -Raw parameter.
$content = Get-Content -Path $inputFile -Raw

# Remove line breaks.
# The pattern "`r`n|`n" covers both Windows (CR+LF) and Unix (LF) line endings.
$cleanedContent = $content -replace "`r`n|`n", ""

# Write the cleaned content to the output file.
Set-Content -Path $outputFile -Value $cleanedContent

Write-Host "Line breaks have been removed. Clean file saved to $outputFile."