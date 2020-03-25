@ECHO OFF

	SET "resourcesPath=%~dp0"
	SET "exportPath=%resourcesPath%assets\router_files\"
	SET "importPath=%resourcesPath%assets\Annotate_Classes\"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "srcPath=%rootPath%\src\"

	if NOT exist dir %exportPath% (
		mkdir %exportPath%
	)
	

:: Remove existing paths
ECHO Cleaning existing routes
	if exist %exportPath%Compile_c.txt del /f %exportPath%Compile_c.txt
	if exist %exportPath%Compile_Java.txt del /f %exportPath%Compile_Java.txt

:: Research through the project due to find commands
START /wait cmd /k call %resourcesPath%\Commander.bat

ECHO Searching routes on src...
	:: Loop through src subfolders
	for /f "tokens=*" %%i in ('dir /b /s /a:d "%srcPath%"') do (
		:: Verify if do exist a .java file on the folder
			:: Concatenate on the .txt the new path
		if exist %%i\*.java (
			if exist %importPath%Command_IgnoreClass.txt (
				for /f "tokens=*" %%j in ('dir /b "%%i"') do (
					CALL :concat %%i %%j
				)
			)
			if NOT Exist %importPath%Command_IgnoreClass.txt (
				@ECHO %%i\*.java>>%exportPath%\Compile_Java.txt
				@ECHO Saved class as \*.java
			)
			@ECHO %%i
		)
	)
	
	CALL :compare
	
EXIT

:: Remove from Compile_Java.txt every path that appears an ignored class
:compare
	for /f "tokens=*" %%l in (%importPath%Command_IgnoreClass.txt) do (
		ECHO rm file = %%l
		for /f "tokens=*" %%X in (
			'findstr /v /e /c:"%%l" "%exportPath%Compile_Java.txt" ^&del "%exportPath%Compile_Java.txt%"'
		) do (
			echo %%X>>%exportPath%Compile_Java.txt
		)
	)

	GOTO :EOF


:: Called on loop to concatenate all the files path
:concat
	SET stringfy=%1\%2
	SET stringfy=%stringfy:*src=src%

	ECHO %stringfy% | find ".java" > nul && (
		@ECHO %1\%2>>%exportPath%Compile_Java.txt
		ECHO Saved on file as %1\%2; 
		GOTO :EOF
	) || (
		ECHO Thrown out - %1\%2
	)

	GOTO :EOF