@ECHO off

    SET "commandsPath=%~dp0"
	SET "rootPath=%commandsPath:commands\=%"
	SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "buildPath=%rootPath%commands\resources\assets\router_files\"
	SET "targetPath=%rootPath%bin\target\"
	SET "binPath=%rootPath%bin\"
	cd %targetPath%

    for /f "tokens=1,2" %%l in (%assetsPath%languages.txt) do (
		:: Grab the paths of .java files found on src
		if exist %buildPath%Build_%%m.txt (
			SET "language=%%l"
			CALL :manifest %%m
		)
	)
        SET mainName=%mainName:.*=%
        %mainName%.exe

    PAUSE
    EXIT

:: Define which is the program appVersion
:manifest
	if NOT ["%ERRORLEVEL%"]==["0"]  EXIT /B 1
	:: If the manifest already exist, it will catch the appVersion and the mainClass
	if exist "%rootPath%manifest_%language%.txt" (
		for /f "tokens=1,2 delims= skip=1" %%i in (%rootPath%manifest_%language%.txt) DO (
          CALL :grabMainName %%i %%j %1
		)
	)

    if NOT exist "%rootPath%manifest_%language%.txt" (
        ECHO Manifest not found.
        EXIT /B 0
    )

    GOTO :EOF

:: Called on manifest loop to grab the manifest mainClass
:grabMainName
    ECHO grabMainName %1 %2 %3
    SET mainName=%2

    ECHO %mainName%

    CALL :getMainName

    ECHO %mainName%

	if NOT defined mainName (
        ECHO ERR: Main file not found.
        PAUSE
        EXIT /B 1
	)
	GOTO :EOF

:: Used to remove all "\" on mainClass to get main file name
:getMainName
    SET "mainName=%mainName:*\=%"
        echo %mainName%|find "\" >nul
            if NOT ["%ERRORLEVEL%"]==["1"] (CALL :getMainName)
    GOTO :EOF
