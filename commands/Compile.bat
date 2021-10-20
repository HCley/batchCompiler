@ECHO off
:: Define path variables
	SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "assetsPath=%resourcesPath%assets\"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "targetPath=%rootPath%bin\target\"
	SET "LOGGER=%resourcesPath%Logger.bat"
	SET "annotateClassesPath=%assetsPath%annotate_classes\"
	SET "routerFilesPath=%assetsPath%router_files\"
	cd %srcPath%

	:: Call batch file to find all .java on project
	CALL %LOGGER% INFO "Routering source code files"
	CALL %resourcesPath%Router.bat 1

	:: Research through the project due to find commands
	CALL %LOGGER% INFO "Finding and executing special commands"
	CALL %resourcesPath%Commander.bat

	:: Clear every previous compiled file
	CALL %LOGGER% INFO "Removing exist compiled files"
	if exist dir %binPath%src ( @RD /s /q %binPath%src )

	:: Create a bin folder if it doesn't exist
	CALL %LOGGER% INFO "Creating bin folder"
	if NOT exist %binPath% MKDIR %binPath%

	:: Create a target folder if it doesn't exist
	CALL %LOGGER% INFO "Creating target folder"
	if NOT exist %targetPath% MKDIR %targetPath%

	for /f "tokens=1,2 delims=, skip=1" %%f in (%assetsPath%languages) do (
		:: Grab the paths of .java files found on src
		if exist %routerFilesPath%Compile_%%f (
			CALL :%%f_compiler %%f %%g
		) else (
			CALL %LOGGER% INFO+ "Not exists %routerFilesPath%Compile_%%f"
			CALL %LOGGER% INFO- "Not exists Compile_%%f"
		)
	)

cd %rootPath%
EXIT /B 0




:: Used to call Java compiler
:java_compiler
	cd %srcPath%
	SET "sourceCode="
	CALL %LOGGER% INFO "Concatenating all %1 source codes"
	for /f %%i in (%routerFilesPath%Compile_%1) DO CALL :concat %%i

	CALL %LOGGER% INFO "Compilling Java files"
	CALL :findMainClass %1
	cd %srcPath%

	for /f "tokens=1,4 delims=, skip=1" %%b in (%assetsPath%languages) DO (
		if "%%b" EQU "%1" (
			:: Call java Compiler, define bin path and .java routes
			CALL %LOGGER% INFO+ "Compilling Java files: %%c -cp .\%mainClass% -d %binPath% %sourceCode%"
			%%c -cp .\%mainClass% -d %binPath% %sourceCode%
		)
	)

	:: If an error has been found, pause batch
	if NOT ["%ERRORLEVEL%"]==["0"] ( 
		CALL %LOGGER% ERR "There was a problem compilling JAVA"
		PAUSE
	)
cd %rootPath%
GOTO :EOF




:: Used to call C++ compiler
:cpp_compiler
	SETLOCAL EnableDelayedExpansion
	CALL %LOGGER% INFO "Compilling C++ files"
	CALL :findMainClass %1
	cd %srcPath%

	:: Get main file name to define output file name
	SET "mainName=%mainClass%"
	SET "mainName=%mainName:.cpp=%"
	@ECHO %mainName%|find "\" > nul
	    if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)

	:: Gets the correct compiler to the language
	for /f "tokens=1,4 delims=, skip=1" %%b in (%assetsPath%languages) DO (
		::Tests if the language is equals the language running
		if "%%b" EQU "%1" (
			:: Walk though every cpp file and compile unliked
			for /f %%i in (%routerFilesPath%Compile_%1) DO (
				SET "file=%%i"
				CALL :outputFile !file!
				SET "outputfile=!outputfile:src=bin\src!"
				SET "outputDir=!outputfile!"
				CALL :outputDir !outputFile!
				
				:: Call C++ Compiler set on language token 4
				CALL %LOGGER% INFO+ "Compilling Java files: %%c -c !file! -o !outputfile!.%2"
				%%c -c !file! -o !outputfile!.%2

				:: If an error has been found, pause batch
				if NOT ["%ERRORLEVEL%"]==["0"] (
					cd %roothPath%
					CALL %LOGGER% WARN "There was a problem compilling C"
					EXIT /B 1
				)
			)
		)
	)

cd %rootPath%
GOTO :EOF

:: Removes the file extension
:outputFile
	for /f "tokens=1,2 delims=." %%a in ("%1") do (
		SET "outputfile=%%a"
	)
GOTO :EOF

:: Create the path as the output needs
:outputDir
	SET "outDir="
	SET "outDirTemp=%1"
	
	CALL :fit %1
	SET "outDir=%outDir:~1%"
    if NOT exist %outDir% (
		MKDIR %outDir%
	)
GOTO :EOF

:fit
    SET "outDirTemp=%outDirTemp:*\=%"
    @ECHO %1|find "\" >nul
        if NOT ["%ERRORLEVEL%"]==["1"] (
			for /f "tokens=1,2 delims=\" %%a in ("%1") do (
				SET "outDir=%outDir%\%%a"
			)

        	CALL :fit %outDirTemp%
        )
GOTO :EOF

:: Used to find the main class
:findMainClass
	cd %srcPath%
	if exist "%annotateClassesPath%Files_Main" (
		for /f "tokens=1" %%a in (%annotateClassesPath%Files_Main) DO (
			SET "mainClass=%%a"
			GOTO :EOF
		)
	)

	for /f "tokens=1,3 delims=, skip=1" %%l in (%assetsPath%languages) DO (
		if "%1" EQU "%%l" (
			for /F "delims=" %%a in (
				'findstr /S /I /M /C:"%%m" *.%%l'
			) do (
				SET mainClass=%%a
			)
		)
		GOTO :EOF
	)

	if NOT defined mainClass (
		CALL %LOGGER% ERR "Main-Class not found on project."
		CALL %LOGGER% INFO "Create one and try again."
		PAUSE
		EXIT /B 1
	)
GOTO :EOF


:: Called on loop to concatenate all the java path files
:concat
	SET stringfy=%1
	SET stringfy=%stringfy:*src=.%
	SET sourceCode=%sourceCode% %stringfy%
GOTO :EOF

:: Used to remove all "\" on mainClass to get main file name
:getMainName
    SET "mainName=%mainName:*\=%"
        @ECHO %mainName%|find "\" >nul
            if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)
GOTO :EOF
