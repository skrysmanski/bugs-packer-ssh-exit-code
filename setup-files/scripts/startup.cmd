@echo off
setlocal

cd /D %~dp0

:: NOTE: tee comes from https://sourceforge.net/projects/unxutils/
::   Unfortunately, it removes all colors from the output on Cmder
::   (but it works fine in Cmd).
:: NOTE 2: tee writes linux line endings. This is why we convert them to
::   Windows line endings below.
powershell -executionpolicy bypass -file %~dp0\startup.ps1 "a:\bootstrap.ps1" | %~dp0\tee.exe "c:\bootstrap.log"

:: Convert LF to CRLF for log file
powershell -command "$cnt = Get-Content 'c:\bootstrap.log'; $cnt | Set-Content -Path 'c:\bootstrap.log'"
