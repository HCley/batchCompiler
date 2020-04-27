@ECHO OFF
	SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "importPath=%rootPath%commands\resources\assets\router_files\"
	SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "binPath=%rootPath%bin\"
	cd %binPath%

	:: Open a new terminal pad and run the .java finder bat.
	:: This command will make the batch wait until compile finish.
	echo Compiling...
	start /wait cmd /k CALL %commandsPath%Compile.bat
	if NOT ["%ERRORLEVEL%"]==["0"] (
		ECHO Fail compiling, the program could not be deployed.
		PAUSE
		EXIT
	)
	:: Open a new terminal pad and run the .class finder bat.
	echo Routering compiled files...
	start /wait cmd /k CALL %resourcesPath%Router.bat 2

	for /f "tokens=2" %%f in (%assetsPath%languages.txt) do (
		:: Grab the paths of .java files found on src
		if exist %importPath%Build_%%f.txt (
			@ECHO Concatenating all %%f source codes
			for /f %%i in (%importPath%Compile_%%f.txt) DO call :concat %%i
			CALL :manifest %%f
		)
	)

	ECHO The language does not need a deploy or do not have one.
	PAUSE
		if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
:: END

:: Create and jar file
:generate.Jar
	if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
	cd %binPath%
	:: Grab the paths of .class files found on bin
	for /f %%i in (%importPath%Build_Class.txt) DO CALL :concat %%i

	:: Run over manifest and print file appVersion created and main class on terminal
	echo Reading Manifest
	for /f "tokens=1,2 delims=" %%i in (%rootPath%manifest.txt) DO echo %%i %%j

	:: Generate jarfile
	echo Generating JAR package
	jar cvfm app.jar %rootPath%manifest.txt %classFiles%


	echo !---- Running app ----!
	:: Run jar file
	start cmd /k CALL %commandsPath%Execute.bat
	TIMEOUT 5
	EXIT

:: Define which is the program appVersion
:manifest
	if NOT ["%ERRORLEVEL%"]==["0"]  EXIT /B 1
	:: If the manifest already exist, it will catch the appVersion and the mainClass
	if exist "%rootPath%manifest_%1.txt" (
		for /f "tokens=1,2 delims=" %%i in (%rootPath%manifest_%1.txt) DO (
			if defined appVersion (
				CALL :grabMainClass %%i %%j %1
			)
			if NOT defined appVersion (
				CALL :grabAppVersion %%i %%j
			)
		)
	)

	:: If the manifest doesn't exist, this will define de appVersion and ask the mainClass name
	if NOT exist "%rootPath%manifest_%1.txt" (
		ECHO Manifest not found. Generating a manifest...
		SET appVersion=1
		CALL :findMainClass %1
	)

	GOTO :generateManifest %1

ECHO ERR: Unexpected error
PAUSE
EXIT /B 1


:: Called on manifest to generate the manifest or update the file
:generateManifest
	if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
	cd %rootPath%
	echo Manifest-Version: %appVersion% >%rootPath%manifest_%1.txt
	echo Main-Class: %mainClass% >>%rootPath%manifest_%1.txt
	GOTO :generate.Jar

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


:: Called on manifest loop to grab the manifest mainClass
:grabMainClass
	SET mainClass=%2
	if NOT defined mainClass (
		call :findMainClass %3
	)
	GOTO :EOF

:: Called on manifest loop to grab the manifest appVersion
:grabAppVersion
	SET appVersion=%2
	SET /A appVersion+=1
	GOTO :EOF


:: Called on loop to concatenate all the files path
:concat
	SET stringfy=%1
	SET stringfy=%stringfy:*src=.\src%
	SET classFiles=%classFiles% %stringfy%
	GOTO :EOF
