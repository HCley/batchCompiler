@ECHO off

	SET "commandPath=%~dp0..\"
	SET "assetsPath=%commandPath%resources\assets\"
	SET "annotatePath=%assetsPath%Annotate_Classes\"
	SET "root=%commandPath%..\"
	SET "binPath=%root%bin"

	ECHO Cleaning build
	if exist %assetsPath%Build_h.txt del /f %assetsPath%Build_h.txt
	if exist %assetsPath%Build_Class.txt del /f %assetsPath%Build_Class.txt

	ECHO Cleaning compile
	if exist %assetsPath%Compile_c.txt del /f %assetsPath%Compile_c.txt
	if exist %assetsPath%Compile_Java.txt del /f %assetsPath%Compile_Java.txt

	ECHO Cleaning Annotate_Classes
	for /F "tokens=*" %%l in (%assetsPath%_AnnotationCommands.txt) do (
		ECHO Cleaning existing routes of the command: %%l
		if exist "%annotatePath%Command_%%l.txt" del /f "%annotatePath%Command_%%l.txt"
	)

	ECHO Cleaning bin
	:: Clear every previous compiled file
	if exist dir %binPath%\src (
		@RD /s /q %binPath%
	)

