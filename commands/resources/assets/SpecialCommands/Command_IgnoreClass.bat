@ECHO off

    SET "commandsPath=%~dp0"
    SET "rootPath=%commandsPath:commands\resources\assets\SpecialCommands\=%"
    SET "srcPath=%rootPath%src\"
    SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "exportPath=%rootPath%commands\resources\assets\router_files\"
    SET "importPath=%rootPath%commands\resources\assets\Annotate_Classes\"

    ECHO Excluding ignored files
    for /f "tokens=1" %%f in (%assetsPath%languages.txt) do (
    	for /f "tokens=*" %%l in (%importPath%Files_IgnoreClass.txt) do (
    		ECHO rm file = %%l
    		for /f "tokens=*" %%X in (
    			'findstr /v /e /c:"%%l" "%exportPath%Compile_%%f.txt" ^&del "%exportPath%Compile_%%f.txt%"'
    		) do (
    			echo %%X>>%exportPath%Compile_%%f.txt
    		)
    	)
    )

EXIT
