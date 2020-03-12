SET exportPath=%~dp0
SET srcPath=%exportPath%..\..\src\

:: Remove existing paths
echo Cleaning existing routes
	if exist %exportPath%\_c.txt del /f %exportPath%\_c.txt
	if exist %exportPath%\_java.txt del /f %exportPath%\_java.txt

echo Searching routes on src...
	:: Loop through src subfolders
	for /f "tokens=*" %%i in ('dir /b /s /a:d "%srcPath%"') do (
		:: Verify if do exist a .java file on the folder
			:: Concatenate on the .txt the new path
		if exist %%i\*.c (
			@echo %%i\*.c>>%exportPath%\_c.txt
		)
		if exist %%i\*.java (
			@echo %%i\*.java>>%exportPath%\_java.txt
		)
	)

EXIT