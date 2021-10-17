@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "srcPath=%rootPath%src\"
	SET "assetsPath=%resourcesPath%assets\"
	SET "importPath=%assetsPath%"
	SET "exportPath=%assetsPath%annotate_classes\"
	SET "specialCommandsPath=%assetsPath%SpecialCommands\"
	SET "LOGGER=%resourcesPath%\Logger.bat"

	if NOT exist %exportPath% (
		mkdir %exportPath%
	)

	GOTO :findCommands

	CALL %LOGGER% ERR "GOT STRIKE"
	PAUSE
		if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1


:: List the structured commands to search for
:findCommands
	cd %root%
	for /F "tokens=1" %%l in (%importPath%_AnnotationCommands) do (
		CALL %LOGGER% INFO "Cleaning existing routes of the command %%l"
		if exist "%exportPath%Files_%%l" del /f "%exportPath%Files_%%l"

		CALL %LOGGER% INFO "Searching through project for %%l"
		call :searchThrough %%l

		if exist "%exportPath%Files_%%l" (
			CALL %LOGGER% INFO "Executing command %%l found"
			CALL %specialCommandsPath%Command_%%l.bat
		)
	)
EXIT /B 0

:: Search through the project by command annotations
:searchThrough
	cd %srcPath%
	CALL %LOGGER% INFO "Search for: @%1"
	for /F "delims=" %%a in (
		'findstr /S /I /M /C:"@%~1" *.*'
	) do (
		@ECHO %%a>>"%exportPath%Files_%~1"
		CALL %LOGGER% INFO "Found on: %%a"
	)
GOTO :EOF
