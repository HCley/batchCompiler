@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "srcPath=%rootPath%src\"
	SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "importPath=%rootPath%commands\resources\assets\"
	SET "exportPath=%rootPath%commands\resources\assets\Annotate_Classes\"
	SET "specialCommandsPath=%rootPath%commands\resources\assets\SpecialCommands\"

	if NOT exist dir %exportPath% (
		mkdir %exportPath%
	)

	GOTO :findCommands

	ECHO GOT STRIKE
	PAUSE
		if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1


:: List the structured commands to search for
:findCommands
cd %root%

	for /F "tokens=1" %%l in (%importPath%_AnnotationCommands.txt) do (

		ECHO Cleaning existing routes of the command %%l
		if exist "%exportPath%Files_%%l.txt" del /f "%exportPath%Files_%%l.txt"

		ECHO Searching through project for %%l
		call :searchThrough %%l

		if exist "%exportPath%Files_%%l.txt" (
			ECHO Executing command %%l found
			start /wait cmd /k CALL %specialCommandsPath%Command_%%l.bat
		)
	)
EXIT

:: Search through the project by command annotations
:searchThrough
	cd %rootPath%
	ECHO Search for: @%1
	for /F "delims=" %%a in (
			'findstr /S /I /M /C:"@%~1" *.*'
		) do (
			@ECHO %%a>>"%exportPath%Files_%~1.txt"
			@ECHO Found on: %%a
		)

	GOTO :EOF
