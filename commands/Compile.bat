@ECHO off
:: Define path variables
	SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "targetPath=%rootPath%bin\target\"
	SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "importPath=%rootPath%commands\resources\assets\router_files\"
	SET "annotateClassesPath=%rootPath%commands\resources\assets\Annotate_Classes\"
	cd %srcPath%

	:: Call batch file to find all .java on project
	@ECHO Routering source code files
	START /wait cmd /k call %resourcesPath%Router.bat 1

	:: Research through the project due to find commands
	@ECHO Finding and executing special commands
	START /wait cmd /k call %resourcesPath%Commander.bat

	:: Clear every previous compiled file
	@ECHO Removing exist compiled files
	if exist dir %binPath%src ( @RD /s /q %binPath%src )

	:: Create a bin folder if it doesn't exist
	@ECHO Creating bin folder
	if NOT exist %binPath% MKDIR %binPath%

	:: Create a target folder if it doesn't exist
	@ECHO Creating target folder
	if NOT exist %targetPath% MKDIR %targetPath%

	for /f "tokens=1" %%f in (%assetsPath%languages.txt) do (
		:: Grab the paths of .java files found on src
		if exist %importPath%Compile_%%f.txt (
			@ECHO Concatenating all %%f source codes
			for /f %%i in (%importPath%Compile_%%f.txt) DO call :concat %%i
			CALL :%%f_compiler %%f
		)
	)

EXIT





:: Used to call java compiler
:java_compiler
	@ECHO Compilling Java files
	call :findMainClass %1
	cd %srcPath%

	:: Call java Compiler, define bin path and .java routes
	javac -cp .\%mainClass% -d %binPath% %sourceCode%

	:: If an error has been found, pause batch
	@ECHO There was a problem compilling JAVA
	if NOT ["%ERRORLEVEL%"]==["0"] PAUSE
	GOTO :EOF


:c_compiler
	@ECHO Compilling C files
	call :findMainClass %1
	cd %srcPath%

	:: Get main file name to define output file name
	SET "mainName=%mainClass%"
	SET "mainName=%mainName:.c=%"
	echo %mainName%|find "\" >nul
	    if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)

	:: Call C Compiler, define bin path and .c routes
	gcc -Wall %sourceCode% -o %mainName%

	:: If everything goes right, move the .exe compiled file to bin
	if ["%ERRORLEVEL%"]==["0"] (
		MOVE %mainName%.exe %targetPath%
	)

	:: If an error has been found, pause batch
	if NOT ["%ERRORLEVEL%"]==["0"] (
		@ECHO There was a problem compilling C
		PAUSE
		EXIT /B 1
	)
	REM PAUSE
	GOTO :EOF





:: Used to find the main class
:findMainClass
	cd %srcPath%

	if exist "%annotateClassesPath%Files_Main.txt" (
		for /f "tokens=1" %%a in (%annotateClassesPath%Files_Main.txt) DO (
			SET "mainClass=%%a"
			GOTO :EOF
		)
	)

	if "%1" EQU "java" (
		ECHO not There
		for /F "delims=" %%a in (
			'findstr /S /I /M /C:"public static void main" *.*'
		) do (
			SET mainClass=%%a
		)
	)

	if "%1" EQU "c" (
		for /F "delims=" %%a in (
			'findstr /S /I /M /C:"int main" *.*'
		) do (
			SET "mainClass=%%a"
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

:: Used to remove all "\" on mainClass to get main file name
:getMainName
    SET "mainName=%mainName:*\=%"
        echo %mainName%|find "\" >nul
            if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)
    GOTO :EOF
