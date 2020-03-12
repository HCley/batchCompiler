//Older
SET mypath=%~dp0
cd %mypath%

%mypath%backup\ClearBackup.bat && %mypath%backup\BackupClass.bat && %mypath%Build.bat && %mypath%Compile.bat

PAUSE


//Old
SET mypath=%~dp0
cd %mypath%

if exist %mypath%..\src\backup\app.class goto has_backup
	if exist %mypath%..\src\app.class goto hasnt_on_backup
	    goto clean_run
    PAUSE
    EXIT /b

:has_backup
if exist %mypath%..\src\app.class goto default_run
    %mypath%Build.bat && cls && %mypath%Compile.bat
    PAUSE
    EXIT /b

:hasnt_on_backup
    %mypath%backup\BackupClass.bat && %mypath%Build.bat && cls && %mypath%Compile.bat
    PAUSE
    EXIT /b


:default_run
    %mypath%backup\ClearBackup.bat && %mypath%backup\BackupClass.bat && %mypath%Build.bat && cls && %mypath%Compile.bat
    PAUSE
    EXIT /b

:clean_run
    %mypath%Build.bat && cls && %mypath%Compile.bat
    PAUSE
    EXIT /b