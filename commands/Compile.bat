:: @ECHO OFF
:: Define path variables
SET "resourcesPath=%~dp0resources\"
SET "importPath=%resourcesPath%assets\router_files\"
SET "srcPath=%resourcesPath%..\..\src\"
SET "binPath=%resourcesPath%..\..\bin\"
cd %srcPath%

:: Call batch file to find all .java on project 
start /wait cmd /k call %resourcesPath%\compile_router.bat

:: Grab the paths of .java files found on src
for /f %%i in (%importPath%\Compile_Java.txt) DO call :concat %%i

:: Create a bin folder if it doesn't exist
if NOT exist %binPath% MKDIR %binPath%

:: Clear every previous compiled file
if exist dir %binPath%\src (
	@RD /s /q %binPath%\src
)

call :findMainClass

cd %srcPath%
:: Call java Compiler, define bin path and .java routes
javac -cp .\%mainClass% -d %binPath% %javaFiles%
:: If an error has been found, pause batch
if NOT ["%ERRORLEVEL%"]==["0"] PAUSE
EXIT


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

	GOTO :EOF


:: Called on loop to concatenate all the java path files
:concat
	SET stringfy=%1
	SET stringfy=%stringfy:*src=.%
	SET javaFiles=%javaFiles% %stringfy%
	GOTO :EOF