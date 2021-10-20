@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
    SET "assetsPath=%resourcesPath%assets\"
    SET "dependenciesPath=%rootPath%Dependencies"
    SET "testCasesPath=%rootPath%src\main\Test\Cases\"
    SET "LOGGER=%resourcesPath%Logger.bat"

    cd %testCasesPath%

    :: Dependencies.txt download files
    :: %%f -> Extension
    :: %%g -> Download to path ()
    :: %%h -> Output name
    :: %%i -> URL
    for /f "tokens=1,2,3,4 skip=1" %%f in (%dependenciesPath%) do (
        CALL %LOGGER% INFO "Downloading %%h%%f on %%g of %%i"
        cd "%rootPath%%%g"
        curl %%i --output %%h%%f

        if "%%f" EQU ".tar" (tar -xvf %%h%%f)
        if "%%f" EQU ".rar" (unrar e %%h%%f)
        if NOT ["%ERRORLEVEL%"]==["0"] (
            PAUSE
            EXIT
        )
        del %%h%%f
    )

    CALL :extractCases
EXIT /B 0


:extractCases
    cd %testCasesPath%
    CALL %LOGGER% INFO "Extracting cases"
    for /f "tokens=*" %%j in ('dir /b "%testCasesPath%"') do (
        gzip -d %%j
    )
    GOTO :EOF
