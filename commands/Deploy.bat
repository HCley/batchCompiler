@ECHO OFF
	SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "assetsPath=%resourcesPath%assets\"
	SET "routerFilesPath=%assetsPath%\router_files\"
	SET "targetPath=%rootPath%bin\target\"
	SET "LOGGER=%resourcesPath%Logger.bat"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "mainClassName="
	SET "packageName="
	SET "classFiles="
	SET "mainClass="
	SET "mainName="
	cd %binPath%

	:: Open a new terminal pad and run the .java finder bat.
	:: This command will make the batch wait until compile finish.
	CALL %LOGGER% INFO "Compiling..."
	CALL %commandsPath%Compile.bat
	if NOT ["%ERRORLEVEL%"]==["0"] (
		CALL %LOGGER% ERR "Fail compiling, the program could not be deployed."
		PAUSE
		EXIT /B 1
	)

	:: Open a new terminal pad and run the .class finder bat.
	CALL %LOGGER% INFO "Routering compiled files..."
	CALL %resourcesPath%Router.bat 2

		:: Grab the paths of .java files found on src
		for /f "tokens=1,2,4 delims=, skip=1" %%l in (%assetsPath%languages) DO if exist %routerFilesPath%Build_%%m (
			SET "classFiles=" 
			CALL %LOGGER% INFO "Concatenating all %%m source codes"
			for /f %%i in (%routerFilesPath%Build_%%m) DO call :concat %%i
			SET "language=%%l"
			CALL :manifest %%m %%n
			if NOT ["%ERRORLEVEL%"]==["0"] (
				CAL %LOGGER% ERR "Error on compiling %%l" %ERRORLEVEL%
				EXIT /B 1
			)
		)
	)

	CALL %LOGGER% WARN "The language does not need a deploy or do not have one."
EXIT /B ["%ERRORLEVEL%"]
:: END


:: Define which is the program appVersion
:manifest
	SETLOCAL EnableDelayedExpansion
	if NOT ["%ERRORLEVEL%"]==["0"]  EXIT /B 1
	:: If the manifest already exist, it will catch the appVersion and the mainClass
	if exist "%rootPath%manifest_%language%" (
		for /f "tokens=1,2 delims=" %%i in (%rootPath%manifest_%language%) DO (
			if defined appVersion (
				CALL :grabMainClass %%i %%j %1
			)
			if NOT defined appVersion (
				CALL :grabAppVersion %%i %%j
			)
		)
	)

	:: If the manifest doesn't exist, this will define de appVersion and ask the mainClass name
	if NOT exist "%rootPath%manifest_%language%" (
		SET appVersion=1
		CALL :findMainClass %1

		CALL %LOGGER% INFO "Converting package"
		CALL :convertToPackage %mainClass%
		CALL %LOGGER% INFO "Finding main name"
		CALL :getMainName
	)

	CALL :generateManifest %1 %2

CALL %LOGGER% INFO "Finished %1 %2"
GOTO :EOF






:: Called on manifest to generate the manifest or update the file
:generateManifest
	SETLOCAL EnableDelayedExpansion
	if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
	cd %rootPath%

	@ECHO Manifest-Version: %appVersion%>%rootPath%manifest_%language%
	if defined packageName (
		@ECHO Main-Class: src%packageName%.%mainClassName%>>%rootPath%manifest_%language%
	) else (
		@ECHO Main-Class: %mainClass%>>%rootPath%manifest_%language%
	)

	::Compilers section
	CALL :generate.%2 %2

GOTO :EOF





:: Used to find the main class
:findMainClass
	SETLOCAL EnableDelayedExpansion
	cd %srcPath%

	if exist "%annotateClassesPath%Files_Main" (
		for /f "tokens=1" %%a in (%annotateClassesPath%Files_Main) DO (
			CALL :removeExtension %%a
			GOTO :EOF
		)
	)

	for /f "tokens=1,2,3 delims=, skip=1" %%l in (%assetsPath%languages) DO (
		if "%1" EQU "%%m" (
			for /F "tokens=*" %%a in ('findstr /S /I /M /C:"%%n" *.%%l') DO (
				CALL :removeExtension src\%%a
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


:: Called on manifest loop to grab the manifest mainClass
:grabMainClass
	SET mainClass=%2
	SET mainClass=%mainClass:.*=%
	SET "mainClassName=%mainClass%"
	call :removeExtension
	if NOT defined mainClass (
		call :findMainClass %3
	)
GOTO :EOF

:: Called on manifest loop to grab the manifest appVersion
:grabAppVersion
	SET appVersion=%2
	SET /A appVersion="%appVersion%"+"1"
GOTO :EOF


:: Called on loop to concatenate all the files path
:concat
	SET stringfy=%1
	SET stringfy=%stringfy:*src=..\src%
	SET classFiles=%classFiles% %stringfy%
GOTO :EOF

:removeExtension
	for /f "tokens=1,2 delims=." %%a in ("%1") do (
		SET "mainClass=%%a"
		SET mainClassName=%mainClass%
	)
GOTO :EOF

:: Used to remove all "\" on mainClass to get main file name
:getMainName
	if NOT defined mainClassName (
	    for /f "tokens=1,2 delims=." %%a in ("%mainClass%") do (
			SET "mainClassName=%%a"
		)
	) else (
	    SET "mainClassName=%mainClassName:*\=%"
	        @ECHO %mainClassName%|find "\" >nul
    	        if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)
	)
GOTO :EOF

:: Replace every \ to .
:convertToPackage
	for /f "tokens=1,2 delims=\" %%a in ("%1") do (
		SET "packageName=%packageName%.%%a"
	)
    SET "mainClass=%mainClass:*\=%"
        @ECHO %mainClass%|find "\" >nul
            if NOT ["%ERRORLEVEL%"]==["1"] (CALL :convertToPackage %mainClass%)
GOTO :EOF





:: COMPILERS -----------------------------------------

:: Create and jar file
:generate.javac
	if NOT ["%ERRORLEVEL%"]==["0"] EXIT /B 1
	cd %targetPath%


	:: Run over manifest and print file appVersion created and main class on terminal
	CALL %LOGGER% INFO "Reading Manifest"
	for /f "tokens=1,2 delims=" %%i in (%rootPath%manifest_java) DO CALL %LOGGER% VERS "%%i %%j"

	:: Generate jarfile
	CALL %LOGGER% INFO "Generating JAR package"
	jar cvfm app.jar %rootPath%manifest_java %classFiles%

	if ["%ERRORLEVEL%"]==["1"] (
		cd %rootPath%
		CALL %LOGGER% ERR "Not able to deploy Java."
		EXIT /B 1
	)

cd %rootPath%
GOTO :EOF


:: Create and exe file
:generate.c++
	cd %targetPath%

	:: Run over manifest and print file appVersion created and main class on terminal
	CALL %LOGGER% INFO "Reading Manifest"
	for /f "tokens=1,2 delims=" %%i in (%rootPath%manifest_cpp) DO CALL %LOGGER% INFO "%%i %%j"
	
	CALL %LOGGER% INFO "Chosing compiler"
	for /f "tokens=4 delims=, skip=1" %%c in (%assetsPath%languages) DO (
		if "%%c" EQU "%1" (
			CALL %LOGGER% INFO "Generating EXE package"
			%%c %classFiles% -o app.exe
		)	
	)

	cd %rootPath%
	if ["%ERRORLEVEL%"]==["1"] (
		CALL %LOGGER% ERR "Not able to deploy C++."
		EXIT /B 1
	) ELSE (
		START CMD /k "3ngine.bat execute"
	)

GOTO :EOF
