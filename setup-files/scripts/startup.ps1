# Launcher script. Makes sure that there is a "pause" whenever there's an error with the actual bootstrap
# script. This allows the user to inspect the error properly (as otherwise the command window would just
# close).
Param(
	[Parameter(Mandatory=$True)]
	[string] $innerScript
)

$script:ErrorActionPreference = 'Stop'

try {
	Invoke-Expression $innerScript
	$innerExitCode = $LASTEXITCODE

	if ($innerExitCode -and $innerExitCode -ne 0) {
		Write-Host "ERROR: '$innerScript' exited with exit code '$innerExitCode'." -ForegroundColor Red

		Pause
	}
	else {
		Write-Host
		Write-Host "Everything is ok" -ForegroundColor Green
		Write-Host

		# Make the success message more visible for the user
		Write-Host "Continuing in 5 seconds..."
		Start-Sleep 5
	}
}
catch {
	Write-Host $_.Exception.Message -ForegroundColor Red
	Write-Host "At $($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)" -ForegroundColor Red

	Pause
}
