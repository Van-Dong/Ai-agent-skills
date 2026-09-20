
@echo off
setlocal

REM Get repository root from script location
for %%I in ("%~dp0..") do set "REPO_ROOT=%%~fI"

set "SKILL_NAME=business-investigator"
set "SOURCE=%REPO_ROOT%\skills\%SKILL_NAME%"
set "TARGET_DIR=%USERPROFILE%\.agents\skills"
set "TARGET=%TARGET_DIR%\%SKILL_NAME%"

echo.
echo Installing Codex Skill: %SKILL_NAME%
echo.

REM Check source directory
if not exist "%SOURCE%\SKILL.md" (
    echo [ERROR] SKILL.md not found:
    echo %SOURCE%\SKILL.md
    exit /b 1
)

REM Create skills directory
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    if errorlevel 1 exit /b 1
)

REM Prevent overwriting existing installation
if exist "%TARGET%" (
    echo [INFO] Skill destination already exists:
    echo %TARGET%
    echo Installation skipped.
    exit /b 0
)

REM Create directory junction
mklink /J "%TARGET%" "%SOURCE%"

if errorlevel 1 (
    echo [ERROR] Failed to create directory junction.
    exit /b 1
)

REM Verify installation
if not exist "%TARGET%\SKILL.md" (
    echo [ERROR] Installation verification failed.
    exit /b 1
)

echo.
echo [SUCCESS] Skill installed successfully!
echo.
echo Source: %SOURCE%
echo Target: %TARGET%
echo.
echo Open a new Codex session and invoke:
echo $business-investigator

exit /b 0