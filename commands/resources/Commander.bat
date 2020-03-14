@ECHO off

	SET commandPath=%~dp0..\
	SET root=%commandPath%..\
	SET assetsPath=%commandPath%resources\assets\
	SET exportPath=%assetsPath%Annotate_Classes\
	SET srcPath=%root%\src\

	
	GOTO :findCommands

	ECHO GOT STRIKE
	PAUSE
		if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1

:: List the structured commands to search for
:findCommands
	cd %root%

	for /F "tokens=1" %%l in (%assetsPath%_AnnotationCommands.txt) do (
		ECHO Cleaning existing routes of the command %%l
		if exist "%exportPath%Command_%%l.txt" del /f "%exportPath%Command_%%l.txt"
		ECHO %%l
		PAUSE
		call :searchThrough %%l
	)
	EXIT

:: Search through the project by command annotations
:searchThrough
	cd %root%

	for /F "delims=" %%a in (
			'findstr /S /I /M /C:"//@%~1" *.*'
		) do (
			@ECHO %%a>>"%exportPath%Command_%~1.txt"
		)

	GOTO :EOF