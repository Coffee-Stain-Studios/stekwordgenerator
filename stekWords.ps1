<#
.DESCRIPTION
A password generator creating passwords that are pronouncable and rememberable. Not for secure usage

.PARAMETER Count
Number of passwords to generate
#>
[CmdletBinding()]
param([Int]$Count = 5)

function capitaliseFirst {
	param( [String]$String )
	return $String.substring(0, 1).toUpper() + $String.substring(1).toLower()
}

Write-Verbose -Message "Reading the three dictionaries"
$doWords = Get-Content doWords.txt
$describeWords = Get-Content describeWords.txt
$actorWords = Get-Content actorWords.txt

# Define allowed numbers to be able to calculate maxCount
$lowestNumber = 100
$highestNumber = 999

Write-Verbose -Message "Calculating the maximum number of possible passwords"
$maxCount = $doWords.Count * $describeWords.Count * $actorWords.Count * ( $highestNumber - $lowestNumber )

Write-Verbose -Message "Maximum available stekwords: $maxCount"

if ( $Count -gt $maxCount ) {
	Write-Error "Count to high; highest allowed number is: $maxCount"
	exit
}

$stekwords = [System.Collections.ArrayList]@()

For ( $i = 0; $i -lt $Count; $i++ ) {
	if ( $count -gt 99 -And $i % 100 -eq 0 ) {
		$percent = [math]::Round(($i / $Count) * 100)
		Write-Progress -Activity "Generating $Count Stekwords" -Status "$percent% Complete" -PercentComplete $percent
	}
	
	$doWord = $doWords | Get-Random
	$describeWord = capitaliseFirst -String ($describeWords | Get-Random)
	$actorWord = capitaliseFirst -String ($actorWords | Get-Random)
	$num = Get-Random -Min $lowestNumber -Max ($highestNumber + 1)
	$stekWord = "$doWord$num$describeWord$actorWord"
	
	$found = $stekwords.IndexOf($stekWord)
	if ( $found -ne -1 ) {
		Write-Verbose -Message "Duplicate of $stekWord found"
		$i--;
		continue
	}
	
	$null = $stekwords.Add($stekWord)
}

Write-Progress -Completed -Activity "Generating $Count Stekwords"

return $stekwords

