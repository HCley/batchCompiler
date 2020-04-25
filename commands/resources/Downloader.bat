@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
    SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "srcPath=%rootPath%src\"
    SET "testPath=%rootPath%src\main\Test\"
    SET "testCasesPath=%rootPath%src\main\Test\Cases\"

    cd %testCasesPath%

    :: Dependencies.txt download files
    :: %%f -> Extension
    :: %%g -> Download to path ()
    :: %%h -> Output name
    :: %%i -> URL
    for /f "tokens=1,2,3,4 skip=1" %%f in (%assetsPath%Dependencies.txt) do (
        @ECHO Downloading %%h%%f on %%g of %%i
        cd "%rootPath%%%g"
        curl %%i --output %%h%%f
        if NOT ["%ERRORLEVEL%"]==["0"] (
            PAUSE
            EXIT
        )

        if %%f EQU ".tar" (tar -xvf %%h%%f)
        if %%f EQU ".rar" (unrar e %%h%%f)
        if %%f EQU ".zip" (wzunzip %%h%%f)
        if NOT ["%ERRORLEVEL%"]==["0"] (
            PAUSE
            EXIT
        )
        del %%h%%f
    )

    REM tar -xvf test_cases.tar
EXIT
