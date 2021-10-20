@ECHO off

    SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "LOGGER=%resourcesPath%Logger.bat"
	SET "assetsPath=%resourcesPath%assets\"
	SET "buildPath=%assetsPath%router_files\"
	SET "targetPath=%rootPath%bin\target\"
	SET "binPath=%rootPath%bin\"
	cd %targetPath%


	app.exe

 rem    for /f "tokens=1,2 delims=, skip=1" %%l in (%assetsPath%languages) do if exist %buildPath%Build_%%m (
	rem 	:: Grab the paths of .java files found on src
	rem 	SET "language=%%l"
	rem 	CALL :manifest %%m
	rem )

 rem    CALL :removeExtencion %mainName%

	rem ECHO %language%
 rem    if "%language%" EQU "java" (
 rem        rem java -jar %mainName%.jar ::PARAM
 rem        java -jar app.jar
 rem    )

 rem    if "%language%" EQU "cpp" (
 rem        %mainName%.exe ::PARAM
 rem    )

cd %rootPath%
EXIT /B 1

:: Define which is the program appVersion
:manifest
	if NOT ["%ERRORLEVEL%"]==["0"]  EXIT /B 1
	:: If the manifest already exist, it will catch the appVersion and the mainClass
	if exist "%rootPath%manifest_%language%" (
		for /f "tokens=1,2 delims= skip=1" %%i in (%rootPath%manifest_%language%) DO (
        	CALL :grabMainName %%i %%j %1
		)
	)

    if NOT exist "%rootPath%manifest_%language%" (
        CALL %LOGGER% ERR "Manifest not found."
        EXIT /B 0
    )

GOTO :EOF

:: Called on manifest loop to grab the manifest mainClass
:grabMainName
    SET mainName=%2
    CALL :getMainName

	if NOT defined mainName (
        CALL %LOGGER% ERR "Main file not found."
		cd %rootPath%
        PAUSE
        EXIT /B 1
	)
GOTO :EOF

:: Used to remove all "\" on mainClass to get main file name
:getMainName
    SET "mainName=%mainName:*.=%"
    @ECHO %mainName%|find "." >nul
        if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)
    GOTO :removeExtencion %mainName%
GOTO :EOF

:removeExtencion
	for /f "tokens=1,2 delims=." %%a in ("%1") do (
		SET "mainName=%%a"
	)
GOTO :EOF