@ECHO off
:: Define path variables
	SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "importPath=%rootPath%resources\assets\router_files\"
	SET "annotateClassesPath=%rootPath%resources\assets\Annotate_Classes\"
	cd %srcPath%

	:: Call batch file to find all .java on project
	@ECHO Routering source code files
	start /wait cmd /k call %resourcesPath%Router.bat 1

	:: Research through the project due to find commands
	@ECHO Finding and executing special commands
	START /wait cmd /k call %resourcesPath%Commander.bat

	:: Clear every previous compiled file
	@ECHO Removing exist compiled files
	if exist dir %binPath%\src ( @RD /s /q %binPath%src )
	:: Create a bin folder if it doesn't exist
	@ECHO Creating bin folder
	if NOT exist %binPath% MKDIR %binPath%

	for /f "tokens=%1" %%f in (%assetsPath%languages.txt) do (
		:: Grab the paths of .java files found on src
		if exist %importPath%\Compile_%%f.txt (
			@ECHO Concatenating all %%f source codes
			for /f %%i in (%importPath%Compile_%%f.txt) DO call :concat %%i

			CALL :compile %%f
		)
	)

EXIT


:: This method is used to select the right compiler
:compile
	if "%1"=="c" call :c_compiler
	if "%1"=="java" call :java_compiler
	GOTO :EOF


:: Used to call java compiler
:java_compiler
	@ECHO Compilling Java files
	call :findMainClass "java"
	cd %srcPath%

	:: Call java Compiler, define bin path and .java routes
	javac -cp .\%mainClass% -d %binPath% %sourceCode%

	:: If an error has been found, pause batch
	@ECHO There was a problem compilling JAVA
	if NOT ["%ERRORLEVEL%"]==["0"] PAUSE
	GOTO :EOF

:_compiler
	@ECHO Compilling C files
	cd %binPath%src\main\c

	:: Call C Compiler, define bin path and .c routes
	gcc -Wall sourceCode

	REM TODO
	REM MOVE ALL COMPILED FILES TO THE RIGHT BIN FOLDER

	:: If an error has been found, pause batch
	@ECHO There was a problem compilling C
	if NOT ["%ERRORLEVEL%"]==["0"] PAUSE

:: Used to find the main class
:findMainClass
	cd %rootPath%


	if exist %annotateClassesPath% (
		for /f "tokens=1" %%i in (%annotateClassesPath%\Files_Main.txt) DO SET "mainClass=%%i"
		SET "mainClass=%mainClass:java.=%"
		SET "mainClass=%mainClass:\=.%"
	)

	if NOT exist %annotateClassesPath% (
		for /F "delims=" %%a in (
			'findstr /S /I /M /C:"public static void main" *.*'
		) do (
			SET mainClass=%%a
		)
	)


	if NOT defined mainClass (
		ECHO ERR: Main-Class not found on project.
		ECHO Create one and try again.
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
