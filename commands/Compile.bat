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

	for /f "tokens=1 delims=, skip=1" %%f in (%assetsPath%languages) do (
		:: Grab the paths of .java files found on src
		if exist %routerFilesPath%Compile_%%f (
			CALL %LOGGER% INFO "Concatenating all %%f source codes"
			for /f %%i in (%routerFilesPath%Compile_%%f) DO CALL :concat %%i
			CALL :%%f_compiler %%f
		) else (
			CALL %LOGGER% INFO+ "Not exists %routerFilesPath%Compile_%%f"
			CALL %LOGGER% INFO- "Not exists Compile_%%f"
		)
	)

cd %rootPath%
EXIT /B 0




:: Used to call Java compiler
:java_compiler
	CALL %LOGGER% INFO "Compilling Java files"
	CALL :findMainClass %1
	cd %srcPath%

	:: Call java Compiler, define bin path and .java routes
	javac -cp .\%mainClass% -d %binPath% %sourceCode%

	:: If an error has been found, pause batch
	if NOT ["%ERRORLEVEL%"]==["0"] ( 
		CALL %LOGGER% ERR "There was a problem compilling JAVA"
		PAUSE
	)
cd %rootPath%
GOTO :EOF


:: Used to call C++ compiler
:cpp_compiler
	CALL %LOGGER% INFO "Compilling C++ files"
	CALL :findMainClass %1
	cd %srcPath%

	:: Get main file name to define output file name
	SET "mainName=%mainClass%"
	SET "mainName=%mainName:.cpp=%"
	@ECHO %mainName%|find "\" > nul
	    if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)

	:: Call C Compiler, define bin path and .c routes
	c++ -Wall %sourceCode% -o %mainName%

	:: If everything goes right, move the .exe compiled file to bin
	if ["%ERRORLEVEL%"]==["0"] (
		MOVE %mainName%.exe %targetPath%
	)

	:: If an error has been found, pause batch
	if NOT ["%ERRORLEVEL%"]==["0"] (
		CALL %LOGGER% INFO "There was a problem compilling C"
		PAUSE
		EXIT /B 1
	)
	REM PAUSE

cd %rootPath%
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
