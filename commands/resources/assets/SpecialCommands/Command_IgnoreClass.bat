@ECHO off

    SET "specialCommandsPath=%~dp0"
    SET "rootPath=%specialCommandsPath:commands\resources\assets\SpecialCommands\=%"
    SET "resourcesPath=%rootPath%commands\resources\"
    SET "assetsPath=%resourcesPath%assets\"
	SET "exportPath=%assetsPath%router_files\"
    SET "LOGGER=%resourcesPath%Logger.bat"

    CALL %LOGGER% INFO "Excluding ignored files"
    for /f "tokens=1" %%f in (%assetsPath%languages) do (
    	for /f "tokens=*" %%l in (%importPath%Files_IgnoreClass) do (
    		CALL %LOGGER% INFO "rm file = %%l"
    		for /f "tokens=*" %%X in (
    			'findstr /v /e /c:"%%l" "%exportPath%Compile_%%f.txt" ^&del "%exportPath%Compile_%%f%"'
    		) do (
    			@ECHO %%X>>%exportPath%Compile_%%f
    		)
    	)
    )

EXIT
