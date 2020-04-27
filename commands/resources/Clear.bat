@ECHO off

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "srcPath=%rootPath%src\"
	SET "binPath=%rootPath%bin\"
	SET "assetsPath=%rootPath%commands\resources\assets\"
	SET "routerFilesPath=%rootPath%commands\resources\assets\router_files\"
	SET "annotatePath=%rootPath%commands\resources\assets\Annotate_Classes\"

	:: Clear every previous built file
	if exist dir %binPath%src (
		ECHO Cleaning bin
		@RD /s /q %binPath%
	)

	:: Clear every previous compiled file
	if exist dir %routerFilesPath% (
		ECHO Cleaning compiled and built routes
		@RD /s /q %routerFilesPath%
	)

	:: Clear every previous commanded classes
	if exist dir %annotatePath% (
		ECHO Cleaning commanded classes path
		@RD /s /q %annotatePath%
	)
