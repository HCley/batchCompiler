@ECHO OFF

	SET "commandPath=%~dp0"
	SET "root=%commandPath%.."
	SET "importPath=%commandPath%resources\assets\router_files\"
	SET "resourcesPath=%commandPath%\resources\"
	SET "binPath=%root%\bin"
	cd %binPath%

	:: Open a new terminal pad and run the .java finder bat.
	:: This command will make the batch wait until compile finish.
	echo Compiling...
	start /wait cmd /k CALL %commandPath%\Compile.bat
	if NOT ["%ERRORLEVEL%"]==["0"] (
		ECHO Fail compiling, the program could not be deployed.
		PAUSE
		EXIT
	)
	:: Open a new terminal pad and run the .class finder bat.
	echo Finding compiled files...
	start /wait cmd /k CALL %resourcesPath%\build_router.bat
	
	GOTO :manifest

	ECHO GOT STRIKE
	PAUSE
		if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
:: END



:: Create manifest and jar file 
:generateJar
	if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
	cd %binPath%
	:: Grab the paths of .class files found on bin
	for /f %%i in (%importPath%\Build_Class.txt) DO CALL :concat %%i

	:: Run over manifest and print file appVersion created and main class on terminal
	echo Reading Manifest
	for /f "tokens=1,2 delims=" %%i in (%root%\manifest.txt) DO echo %%i %%j

	:: Generate jarfile
	echo Generating JAR package
	jar cvfm app.jar %root%\manifest.txt %classFiles%


	echo !---- Running app ----!
	:: Run jar file
	start cmd /k CALL java -jar App.jar
	TIMEOUT 5
	EXIT



:: Define which is the program appVersion
:manifest
	if NOT ["%ERRORLEVEL%"]==["0"]  EXIT /B 1
	:: If the manifest already exist, it will catch the appVersion and the mainClass
	if exist "%root%\manifest.txt" (
		for /f "tokens=1,2 delims=" %%i in (%root%\manifest.txt) DO (
			if defined appVersion (
				CALL :grabMainClass %%i %%j
			)
			if NOT defined appVersion (
				CALL :grabAppVersion %%i %%j
			)
		)	
	)

	:: If the manifest doesn't exist, this will define de appVersion and ask the mainClass name
	if NOT exist "%root%\manifest.txt" (
		ECHO Manifest not found. Generating a new one...
		SET appVersion=1
		CALL :findMainClass
	)

	GOTO :generateManifest

ECHO ERR: Unespected error
PAUSE
EXIT /B 1


:: Called on manifest to generate the manifest or update the file
:generateManifest
	if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
	cd %root%
	echo Manifest-Version: %appVersion% >%root%\manifest.txt
	echo Main-Class: %mainClass% >>%root%\manifest.txt
	GOTO :generateJar

:: Search through the project by the main class
:findMainClass
	cd %root%

	for /F "delims=" %%a in (
		'findstr /S /I /M /C:"public static void main" *.*'
	) do (
		SET mainClass=%%a
	)
	if NOT defined mainClass (
		ECHO ERR: Main-Class not found on project.
		ECHO Create one and try again.
			PAUSE
		EXIT /B 1
	)

	SET mainClass=%mainClass:.java=%
	SET mainClass=%mainClass:\=.%


	cd %binPath%
	GOTO :EOF

:: Called on manifest loop to grab the manifest mainClass
:grabMainClass
	SET mainClass=%2
	if NOT defined mainClass (
		call :findMainClass
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