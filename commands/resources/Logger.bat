@ECHO OFF

	SET "resourcesPath=%~dp0"
	SET "rootPath=%resourcesPath:commands\resources\=%"
	SET "assetsPath=%resourcesPath%assets\"
	SET "loggerLevelPath=%assetsPath%LoggerLevel"
	SET "LOGGER_LEVEL=%1"


if "%LOGGER_LEVEL%" EQU "DEBG" (
	@ECHO %1 %2 %3
)

for /f "tokens=1 skip=1" %%l in (%loggerLevelPath%) DO (
	if "%%l" EQU "ANY" (
		@ECHO %1 %2 %3
		GOTO :EOF
	)
	if "%LOGGER_LEVEL%" EQU "%%l" (
		@ECHO %1 %2 %3
	)
)