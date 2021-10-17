@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "resourcesPath=%rootPath%commands\resources\"
	SET "assetsPath=%resourcesPath%assets\"
	SET "binPath=%rootPath%bin\"
	SET "routerFilesPath=%assetsPath%router_files\"
	SET "annotatePath=%assetsPath%annotate_classes\"
	SET "LOGGER=%resourcesPath%Logger.bat"

	:: Clear every previous built file
	if exist dir %binPath%src (
		CALL %LOGGER% INFO "Cleaning bin"
		@RD /s /q %binPath%
	)

	:: Clear every previous compiled file
	if exist dir %routerFilesPath% (
		CALL %LOGGER% INFO "Cleaning compiled and built routes"
		@RD /s /q %routerFilesPath%
	)

	:: Clear every previous commanded classes
	if exist dir %annotatePath% (
		CALL %LOGGER% INFO "Cleaning commanded classes path"
		@RD /s /q %annotatePath%
	)
