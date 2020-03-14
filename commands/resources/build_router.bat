	SET "exportPath=%~dp0assets\"
	SET "binPath=%exportPath%..\..\..\bin\"
	cd %exportPath%

:: Remove existing paths
echo Cleaning existing routes
	if exist %exportPath%\Build_h.txt del /f %exportPath%\Build_h.txt
	if exist %exportPath%\Build_Class.txt del /f %exportPath%\Build_Class.txt

echo Searching routes on bin...
	:: Loop through src subfolders
	for /f "tokens=*" %%i in ('dir /b /s /a:d "%binPath%"') do (
		:: Verify if do exist a .java file on the folder
			:: Concatenate on the .txt the new path
		if exist %%i\*.h (
			@echo %%i\*.h>>%exportPath%\Build_h.txt
		)
		if exist %%i\*.class (
			@echo %%i\*.class>>%exportPath%\Build_Class.txt
		)
	)
EXIT