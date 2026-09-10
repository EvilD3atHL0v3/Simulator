@echo off
setlocal enabledelayedexpansion

set "LOG_FILE=sim_mission.log"

:MENU
cls
========================================================
           SECURITY OPERATIONS SIMULATOR
========================================================
  [1] Create / Reset Simulation Log File
  [2] Play Capture Log (Incident Investigation Quiz)
  [3] Exit
========================================================
set /p "choice=Select an option (1-3): "

if "%choice%"=="1" goto GENERATE_LOG
if "%choice%"=="2" goto PLAY_QUIZ
if "%choice%"=="3" exit /b

goto MENU

:GENERATE_LOG
cls
echo [+] Generating advanced security log (%LOG_FILE%)...
echo [2026-06-06 07:00:00] [SYSTEM] SIEM monitoring agent started. > "%LOG_FILE%"

:: Loop to generate 200 log entries with embedded clues
for /L %%i in (1,1,200) do (
    set /A "randIP=%RANDOM% % 50 + 1"
    
    if %%i==15 (
        echo [2026-06-06 08:15:22] [AUTH_SUCCESS] User 'johndoe' logged in successfully from workstation 192.168.1.50. >> "%LOG_FILE%"
    ) else if %%i==45 (
        echo [2026-06-06 09:30:10] [ACTIVITY] User 'johndoe' accessed company shared resource. >> "%LOG_FILE%"
    ) else if %%i==100 (
        echo [2026-06-06 11:00:15] [AUTH_SUCCESS] User 'sysadmin' logged in successfully from IP 192.168.1.10. >> "%LOG_FILE%"
    ) else if %%i==120 (
        echo [2026-06-06 11:15:00] [MALICIOUS_ALERT] Suspicious session established from external IP 203.0.113.99 using compromised credentials. >> "%LOG_FILE%"
    ) else if %%i==125 (
        echo [2026-06-06 11:16:44] [MALICIOUS_ALERT] Hidden message payload delivered: "FLAG{cmd_line_hunter_2026}" >> "%LOG_FILE%"
    ) else (
        echo [2026-06-06 08:00:%%i] [BACKGROUND] Network heartbeat node 192.168.1.!randIP! active. >> "%LOG_FILE%"
    )
)
echo [+] Log generation complete! Press any key to return to menu.
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
echo     INCIDENT INVESTIGATION CAPTURE GAME
echo ========================================================
echo Use 'findstr' mentally or in another window to investigate!
echo.

:: Question 1
set /p "ans1=Q1: Who is the legit user mentioned in the logs? "
if /i "%ans1%"=="johndoe" (
    echo [+] Correct! johndoe is authorized.
) else (
    echo [-] Incorrect. (Hint: Look for AUTH_SUCCESS and common names)
)
echo.

:: Question 2
set /p "ans2=Q2: What IP address belongs to the malicious attacker? "
if "%ans2%"=="203.0.113.99" (
    echo [+] Correct! 203.0.113.99 is external and flagged.
) else (
    echo [-] Incorrect. (Hint: Look for external ranges like 203.0.113.xx)
)
echo.

:: Question 3
set /p "ans3=Q3: What hidden message flag did the attacker drop? "
if /i "%ans3%"=="FLAG{cmd_line_hunter_2026}" (
    echo [+] Correct! You successfully extracted the flag!
) else (
    echo [-] Incorrect. (Hint: Look for payloads containing 'FLAG')
)

echo.
echo ========================================================
echo Investigation Complete! 
echo Tip: You can type 'findstr /i "keyword" %LOG_FILE%' in a separate 
echo command prompt window to inspect the raw data anytime.
echo ========================================================
pause
goto MENU
