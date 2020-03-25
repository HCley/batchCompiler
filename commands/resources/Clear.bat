@ECHO off

	SET "commandPath=%~dp0..\"
	SET "assetsPath=%commandPath%resources\assets\"
	SET "routerFilesPath=%assetsPath%router_files\"
	SET "annotatePath=%assetsPath%Annotate_Classes\"
	SET "root=%commandPath%..\"
	SET "binPath=%root%bin"

	ECHO Cleaning bin
	:: Clear every previous built file
	if exist dir %binPath%\src (
		@RD /s /q %binPath%
	)

	ECHO Cleaning compiled and built routes
	:: Clear every previous compiled file
	if exist dir %routerFilesPath% (
		@RD /s /q %routerFilesPath%
	)

	ECHO Cleaning commanded classes path
	:: Clear every previous commanded classes
	if exist dir %annotatePath% (
		@RD /s /q %annotatePath%
	)