SET exportPath=%~dp0
SET binPath=%exportPath%..\..\bin\

:: Remove existing paths
echo Cleaning existing routes
	if exist %exportPath%\_h.txt del /f %exportPath%\_h.txt
	if exist %exportPath%\_class.txt del /f %exportPath%\_class.txt

echo Searching routes on bin...
	:: Loop through src subfolders
	for /f "tokens=*" %%i in ('dir /b /s /a:d "%binPath%"') do (
		:: Verify if do exist a .java file on the folder
			:: Concatenate on the .txt the new path
		if exist %%i\*.h (
			@echo %%i\*.h>>%exportPath%\_h.txt
		)
		if exist %%i\*.class (
			@echo %%i\*.class>>%exportPath%\_class.txt
		)
	)
	
EXIT