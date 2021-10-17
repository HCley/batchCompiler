:: * HEADER
:: PARAMS %1 (null || deploy || compile || execute)
:: %1 == null || deploy -> 
:: %1 == compile -> 
:: %1 == execute -> 
@ECHO off

SET "commandsPath=%~dp0/commands/"
SET "deploy=%commandsPath%Deploy.bat"
SET "compile=%commandsPath%Compile.bat"
SET "execute=%commandsPath%Execute.bat"
SET "clear=%commandsPath%resources/Clear.bat"
SET "router=%commandsPath%resources/Router.bat"
SET "engineInvokeParam=%1"
SET "setInvokeParam=%2"


if NOT defined engineInvokeParam (
	SET "engineInvokeParam=%deploy%"
)

if "%engineInvokeParam%" EQU "run" (
	SET "engineInvokeParam=%deploy%"
)
if "%engineInvokeParam%" EQU "compile" (
	SET "engineInvokeParam=%compile%"
)
if "%engineInvokeParam%" EQU "execute" (
	SET "engineInvokeParam=%execute%"
)
if "%engineInvokeParam%" EQU "clear" (
	SET "engineInvokeParam=%clear%"
)
if "%engineInvokeParam%" EQU "router" (
	SET "engineInvokeParam=%router% 1"
)
if "%engineInvokeParam%" EQU "loggerlevel" (
	if NOT defined setInvokeParam (
		@ECHO Logger level must be defined at least as ANY 
		GOTO :EOF
	)
	call :setLoggerLevel
)

CALL %engineInvokeParam%
rem del manifest_java
GOTO :EOF

:setLoggerLevel
	@ECHO %2
GOTO:EOF