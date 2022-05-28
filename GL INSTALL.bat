:: Batch script to install all GL files in DevCpp
@echo off

:: CHECKING ADMINISTRATOR
CALL :check_perm
EXIT /B %ERRORLEVEL%

:check_perm
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Running as Administrator
    GOTO :MAIN
) else (
    echo Failure: Please run the batch as ADMINISTRATOR! 
    pause 
    EXIT
)
EXIT /B 0


:MAIN
:: setting directory of the executed batch file
set "pwd=%~dp0"  
SETLOCAL EnableDelayedExpansion
:: Determine which DevCpp version DevCpp<5 or DevCpp>5
if exist "C:\Program Files (x86)\Dev-Cpp" (
    set "PREFIX=C:\Program Files (x86)\Dev-Cpp\MinGW64"
    CALL :INSTALLATION "!PREFIX!"
    EXIT /B %ERRORLEVEL%
) else (
    if exist "C:\Program Files (x86)\Embarcadero" (
        set "PREFIX=C:\Program Files (x86)\Embarcadero\Dev-Cpp\TDM-GCC-64"
        CALL :INSTALLATION "!PREFIX!"
        EXIT /B %ERRORLEVEL%
    ) else (
        echo "DevC++ Not Installed or installation directory is not in C:\ drive"
        PAUSE
        EXIT 
    )
)

:INSTALLATION
:: Setting source path for the files


echo =================================
echo         Installing GLUT       
echo =================================
set "include=%pwd%freeglut\include\GL\"
set "lib=%pwd%freeglut\lib\x64\"
set "system32=%pwd%freeglut\bin\x64\"

@REM ! TEST PURPOSE
@REM echo "------Source Folder---------"
@REM echo "!include!"
@REM echo "!lib!"
@REM echo "!system32!"
@REM echo "---------------"

:: Setting destination path
set "includeDes=%~1%\include\GL\"
set "libDes=%~1%\lib\x64\"
set "system32Des=C:\Windows\System32\" 

@REM ! TEST PURPOSE
@REM echo "------Destination Folder---------"
@REM echo "!includeDes!"
@REM echo "!libDes!"
@REM echo "!system32Des!"
@REM echo "---------------"

:: check if destination path exist else create the folder
CALL :checkFolder "!includeDes!"
CALL :checkFolder "!libDes!"

:: COPY all the files 
xcopy "!include!" "!includeDes!" /s /e /f /y
xcopy "!lib!" "!libDes!" /s /e /f /y
xcopy "!system32!" "!system32Des!" /s /e /f /y

echo.
echo.
echo "INSTALLATION SUCCESS"
echo.
echo.
echo "---------- Last Step ------------"
echo "1. Open DevC++"
echo "2. Goto Tools > Compiler Options"
echo "3. Set 'Compiler set to configure ->>> *** Debug'"
echo "4. Tick -> Add the following commands when calling the compiler"
echo "5. Enter '-lopengl32 -lfreeglut -lglu32' without quotes '' "
echo "6. Click Ok."
echo "7. You are all set! Enjoy"
echo.
echo.
pause

EXIT /B %ERRORLEVEL%


:: function to check if location path exist if not create new folder
:checkFolder
if not exist "%~1" (
    mkdir "%~1"
)
EXIT /B 0

EXIT /B 0
ENDLOCAL

EXIT /B 0