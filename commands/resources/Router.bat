:: * HEADER
:: PARAMS %1 (1 || 2)
:: %1 == 1 -> Search through src folder by source code
:: %1 == 2 -> Search through bin folder by compiled code
@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "exportPath=%rootPath%commands\resources\assets\router_files\"
	SET "importPath=%rootPath%commands\resources\assets\Annotate_Classes\"
	if "%1" EQU "1" (
		SET "searchThrough=%srcPath%"
		SET "ExportName=Compile_"
	)
	if "%1" EQU "2" (
		SET "searchThrough=%binPath%"
		SET "ExportName=Build_"
	)


	if NOT exist dir %exportPath% (
		mkdir %exportPath%
	)


:: Loop through all languages to compile
for /f "tokens=%1" %%f in (%assetsPath%languages.txt) do (

	:: Remove existing paths
	CALL :clear %%f

	ECHO Searching routes through %searchThrough% folder for %%f ...

	:: Loop through src subfolders
	for /f "tokens=*" %%i in ('dir /b /s /a:d "%searchThrough%"') do (
		@ECHO searching through %%i
		
			:: Verify if do exist a .%%f_ file on the folder
			:: Concatenate on the .txt the new path
			if exist %%i\*.%%f (
				for /f "tokens=*" %%j in ('dir /b "%%i"') do (
					CALL :concat %%i %%j %%f %1
				)
			)
			@ECHO %%i
		)
	)
EXIT

:: Called on loop to concatenate all the files path
:concat
	SET stringfy=%1\%2
	SET stringfy=%stringfy:*src=src%
	ECHO %stringfy% | find ".%3" > nul && (
		@ECHO %1\%2>>%exportPath%%ExportName%%3.txt
		ECHO Saved on file as %1\%2;
		GOTO :EOF
	) || (
		ECHO Thrown out - %1\%2
	)
	GOTO :EOF

:: Called on loop to clear all the files found before
:clear
	ECHO Removing %ExportName%%1
	if exist %exportPath%%ExportName%%1.txt del /f %exportPath%%ExportName%%1.txt
	GOTO :EOF
