@echo off
setlocal enabledelayedexpansion

set "LOG_FILE=sim_advanced.log"

:MENU
cls
========================================================
       ADVANCED SSH INCIDENT OPERATIONS SIMULATOR
========================================================
  [1] Generate / Reset Advanced Simulation Log
  [2] Play Capture Log (Advanced Investigation Quiz)
  [3] Exit
========================================================
set /p "choice=Select an option (1-3): "

if "%choice%"=="1" goto GENERATE_LOG
if "%choice%"=="2" goto PLAY_QUIZ
if "%choice%"=="3" exit /b

goto MENU

:GENERATE_LOG
cls
echo [+] Generating advanced SSH attack log with randomized timestamps...
echo [2026-06-06 00:00:00] [SYSTEM] SSH monitoring audit log initialized. > "%LOG_FILE%"

:: Loop to generate 200 log entries with structured narrative events
for /L %%i in (1,1,200) do (
    set /A "randHour=%RANDOM% % 24"
    set /A "randMin=%RANDOM% % 60"
    set /A "randSec=%RANDOM% % 60"
    set /A "randIP=%RANDOM% % 50 + 1"

    if !randHour! lss 10 set "randHour=0!randHour!"
    if !randMin! lss 10 set "randMin=0!randMin!"
    if !randSec! lss 10 set "randSec=0!randSec!"
    set "TIMESTAMP=2026-06-06 !randHour!:!randMin!:!randSec!"

    :: Scenario Mapping
    if %%i geq 10 if %%i leq 20 (
        echo [!TIMESTAMP!] Failed SSH connection attempt for user 'admin', 'guest', 'user1', 'user2', 'user3', 'user4', 'user5' from external IP 203.0.113.50. >> "%LOG_FILE%"
    ) else if %%i==21 (
        echo [!TIMESTAMP!] Successful SSH authentication for user 'guest' from IP 203.0.113.50. >> "%LOG_FILE%"
    ) else if %%i==35 (
        echo [!TIMESTAMP!] User 'guest' executed command to create new accounts: 'user6' and 'user7'. >> "%LOG_FILE%"
    ) else if %%i geq 50 if %%i leq 70 (
        echo [!TIMESTAMP!] Continuous attack: Failed SSH authentication attempt for user 'user6' and 'user7'. >> "%LOG_FILE%"
    ) else if %%i==62 (
        echo [!TIMESTAMP!] User account 'user2' modified and renamed/escalated to 'UserA' by administrative command. >> "%LOG_FILE%"
    ) else if %%i geq 80 if %%i leq 95 (
        echo [!TIMESTAMP!] Ongoing brute-force attack targeting account 'UserA'. >> "%LOG_FILE%"
    ) else if %%i==96 (
        echo [!TIMESTAMP!] Successful SSH authentication made for account 'UserA' from external IP 203.0.113.50. >> "%LOG_FILE%"
    ) else (
        echo [!TIMESTAMP!] Network routine heartbeat node 192.168.1.!randIP! active. >> "%LOG_FILE%"
    )
)

echo [+] Log generation complete with randomized timeline! Press any key to return to menu.
pause >nul
goto MENU

:PLAY_QUIZ
cls
if not exist "%LOG_FILE%" (
    echo [!] Error: Log file not found! Please run option [1] first.
    pause
    goto MENU
)

echo ========================================================
echo     ADVANCED INCIDENT INVESTIGATION CAPTURE QUIZ
echo ========================================================
echo Tip: Use a separate command prompt to run 'findstr /i "keyword" %LOG_FILE%'
echo.

:: Question 1
set /p "ans1=Q1: Which account had a successful SSH authentication during the initial brute force phase? "
if /i "%ans1%"=="guest" (
    echo [+] Correct! The 'guest' account was successfully compromised via SSH.
) else (
    echo [-] Incorrect. (Hint: Look for early SSH_SUCCESS entries)
)
echo.

:: Question 2
set /p "ans2=Q2: What new users did the guest account create after gaining access? "
if /i "%ans2%"=="user6 and user7" (
    echo [+] Correct! They created user6 and user7 to extend the attack.
) else (
    echo [-] Incorrect. (Hint: Look for account creation indicators)
)
echo.

:: Question 3
set /p "ans3=Q3: Which original user account was modified into 'UserA' during the incident? "
if /i "%ans3%"=="user2" (
    echo [+] Correct! user2 was modified/escalated to UserA.
) else (
    echo [-] Incorrect. (Hint: Look for ACCOUNT_MODIFY events)
)
echo.

:: Question 4
set /p "ans4=Q4: Which account ultimately made a successful SSH authentication after brute forcing? "
if /i "%ans4%"=="UserA" (
    echo [+] Correct! UserA achieved the final successful SSH login.
) else (
    echo [-] Incorrect. (Hint: Check the final stages of the attack timeline)
)

echo.
echo ========================================================
echo Investigation Module Completed!
echo ========================================================
pause
goto MENU
