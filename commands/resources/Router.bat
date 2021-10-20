:: * HEADER
:: PARAMS %1 (1 || 2)
:: %1 == 1 -> Search through src folder by source code
:: %1 == 2 -> Search through bin folder by compiled code
@ECHO OFF

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "assetsPath=%resourcesPath%assets\"
	SET "languagesPath=%assetsPath%languages"
	SET "exportPath=%assetsPath%router_files\"
	SET "LOGGER=%resourcesPath%Logger.bat"
	SET "routerInvokeParam=%1"


	if NOT defined routerInvokeParam (
		SET "routerInvokeParam=1"
	)
	if "%routerInvokeParam%" EQU "1" (
		SET "searchThrough=%srcPath%"
		SET "ExportName=Compile_"
	)
	if "%routerInvokeParam%" EQU "2" (
		SET "searchThrough=%binPath%"
		SET "ExportName=Build_"
	)

	:: Create a export folder if it doesn't exist
	CALL %LOGGER% INFO "Creating bin folder"
	if NOT exist %exportPath% MKDIR %exportPath%

cd %rootPath%
:: Loop through all languages validating if exist on the projects folder
for /f "tokens=%routerInvokeParam% delims=, skip=1" %%f in (%languagesPath%) DO (
	CALL %LOGGER% INFO "Searching routes through %searchThrough% folder for %%f ..."

	rem :: Remove existing paths
	CALL :clear %%f


	:: Loop through all searchThrough folders and subfolders
	:: Verify if do exist a .%%f_ file on the folder
	:: Concatenate on the .txt the new path
	if exist %searchThrough% (
		for /f "tokens=1" %%i in ('dir /b/s/a:d %searchThrough%') DO if exist %%i\*.%%f (
			for /f "tokens=1" %%j in ('dir /b "%%i"') DO if exist %%i\*.%%f (
				CALL :concat %%i %%j %%f %routerInvokeParam%
			)
		)
	)
)
EXIT /B 0

:: Called on loop to concatenate all the files path
:concat
	SET "stringfy=%1\%2"
	@ECHO %stringfy% | find ".%3" > nul && (
		@ECHO %1\%2>>%exportPath%%ExportName%%3
		CALL %LOGGER% SAVE "Saved on file as %1\%2;"
		GOTO :EOF
	) || (
		CALL %LOGGER% EXCP "Thrown out - %1\%2"
	)
GOTO :EOF

:: Called on loop to clear all the files found before
:clear
	CALL %LOGGER% INFO "Removing %ExportName%%1"
	if exist %exportPath%%ExportName%%1 (
		del /f %exportPath%%ExportName%%1
	)
GOTO :EOF
