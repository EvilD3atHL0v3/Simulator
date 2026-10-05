@echo off
color 2
setlocal enabledelayedexpansion

:MENU
cls
echo ========================================================
echo           SECURITY OPERATIONS SIMULATOR
echo ========================================================
echo  [1] Create / Reset Simulation Log File
echo  [2] Play Capture Log (Incident Investigation Quiz)
echo  [3] Exit
echo ========================================================
set /p "choice=Select an option (1-3): "

if "%choice%"=="1" goto GENERATE_LOG
if "%choice%"=="2" goto PLAY_QUIZ
if "%choice%"=="3" exit /b

goto MENU

:GENERATE_LOG
set "LOG_FILE=%~dp0sim_interactive_mission.log"
cls


:: Get today's date
for /f %%a in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set "TODAY=%%a"

echo [+] Generating security log...
echo.

:: Start simulated time from current system time
for /f "tokens=1-3 delims=:." %%a in ("!TIME!") do (
    set /A "logHour=%%a"
    set /A "logMin=%%b"
    set /A "logSec=%%c"
)

set /A "logSeconds=logHour*3600 + logMin*60 + logSec"

echo [!TODAY! !TIME:~0,8!] [SYSTEM] SIEM monitoring agent started. > "%LOG_FILE%"

:: Generate 1000 log entries
for /L %%i in (1,1,1000) do (

    :: Advance simulated time by 1-10 seconds
    set /A "increment=!RANDOM! %% 10 + 1"
    set /A "logSeconds+=increment"

    :: Prevent time from going beyond 24 hours
    if !logSeconds! GEQ 86400 set /A "logSeconds-=86400"

    :: Calculate HH:MM:SS without using modulo
    set /A "logHour=logSeconds / 3600"
    set /A "remaining=logSeconds - (logHour * 3600)"
    set /A "logMin=remaining / 60"
    set /A "logSec=remaining - (logMin * 60)"

    :: Add leading zeros
    if !logHour! LSS 10 set "logHour=0!logHour!"
    if !logMin! LSS 10 set "logMin=0!logMin!"
    if !logSec! LSS 10 set "logSec=0!logSec!"

    set "LIVE_TIME=!logHour!:!logMin!:!logSec!"

    :: Random username
    set /A "userIndex=!RANDOM! %% 4"

    if !userIndex! EQU 0 set "randUser=admin"
    if !userIndex! EQU 1 set "randUser=guest"
    if !userIndex! EQU 2 set "randUser=sysadmin"
    if !userIndex! EQU 3 set "randUser=administrator"

    :: Random IP
    set /A "randOctet1=!RANDOM! %% 254 + 1"
    set /A "randOctet2=!RANDOM! %% 254 + 1"
    set "ATKIP=203.0.113.1"
    set "IOCIP=203.0.113.99"
    :: Random file
    set /A "fileIndex=!RANDOM! %% 4"

    if !fileIndex! EQU 0 set "randFile=salary.txt"
    if !fileIndex! EQU 1 set "randFile=payroll.txt"
    if !fileIndex! EQU 2 set "randFile=file.txt"
    if !fileIndex! EQU 3 set "randFile=note.txt"
:: ============================================    	
:: Embedded investigation clues
:: ============================================
    if %%i==15 (
        echo [%TODAY% !LIVE_TIME!] [AUTH_SUCCESS] User 'evildeathlove' logged in successfully from workstation 192.168.1.50. >> "%LOG_FILE%"
    ) else if %%i GEQ 45 if %%i LEQ 50 (
        echo [%TODAY% !LIVE_TIME!] [ACTIVITY] User 'evildeathlove' accessed company shared resource. >> "%LOG_FILE%"
    ) else if %%i==100 (
        echo [%TODAY% !LIVE_TIME!] [AUTH_SUCCESS] User 'sysadmin' logged in successfully from IP 192.168.1.10. >> "%LOG_FILE%"
    
    ) else if %%i GEQ 121 if %%i LEQ 125 (
        echo [%TODAY% !LIVE_TIME!] [ACTIVITY] User 'evildeathlove' accessed company shared resource. >> "%LOG_FILE%"
   ) else if %%i GEQ 130 if %%i LEQ 150 (
        echo [%TODAY% !LIVE_TIME!] [AUTH_FAILURE] User '!randUser!' failed login from IP 203.0.!randOctet1!.!randOctet2!. >> "%LOG_FILE%"   
   ) else if %%i==151 (
        echo [%TODAY% !LIVE_TIME!] [AUTH_SUCCESS]  User 'admin123' logged in successfully from !ATKIP!. >> "%LOG_FILE%"
   ) else if %%i GEQ 152 if %%i LEQ 300 (
        echo [%TODAY% !LIVE_TIME!] [AUTH_FAILURE] User '!randUser!' failed login from IP 203.0.!randOctet1!.!randOctet2!. >> "%LOG_FILE%"  
   ) else if %%i GEQ 350 if %%i LEQ 500 (
        echo [%TODAY% !LIVE_TIME!] [ACTIVITY] User 'evildeathlove' accessed company shared resource. >> "%LOG_FILE%"
   ) else if %%i GEQ 350 if %%i LEQ 599 (
        echo [%TODAY% !LIVE_TIME!] [ACTIVITY] User 'evildeathlove' modified file '!randFile!' >> "%LOG_FILE%"
  ) else if %%i==600 (
        echo [%TODAY% !LIVE_TIME!] [ACTIVITY] User 'admin123' modified file 'password.txt' >> "%LOG_FILE%"
  ) else if %%i GEQ 601 if %%i LEQ 730 (
        echo [%TODAY% !LIVE_TIME!] [ACTIVITY] User 'evildeathlove' modified file '!randFile!' >> "%LOG_FILE%"
   ) else if %%i==751 (
        echo [%TODAY% !LIVE_TIME!] [MALICIOUS_ALERT] Suspicious session established from external IP !IOCIP! using compromised credentials. >> "%LOG_FILE%"
    ) else if %%i==800 (
        echo [%TODAY% !LIVE_TIME!] [BACKGROUND] Hidden message payload delivered: "FLAG{BRuT3-F0rC3-Att5cK}" >> "%LOG_FILE%"
    ) else (
        ::echo [%TODAY% !LIVE_TIME!] [BACKGROUND] Agent status beacon received from endpoint 192.168.1.10. >> "%LOG_FILE%"
	set /A "bgIndex=!RANDOM! %% 5"
	 if !bgIndex! EQU 0 (
            echo [%TODAY% !LIVE_TIME!] [BACKGROUND] Agent status beacon received from endpoint 192.168.1.10. >> "%LOG_FILE%"
        ) else if !bgIndex! EQU 1 (
            echo [%TODAY% !LIVE_TIME!] [BACKGROUND] ICMP echo response received from gateway 192.168.1.10. >> "%LOG_FILE%"
        ) else if !bgIndex! EQU 2 (
            echo [%TODAY% !LIVE_TIME!] [BACKGROUND] System telemetry sync completed for node 192.168.1.10. >> "%LOG_FILE%"
        ) else if !bgIndex! EQU 3 (
            echo [%TODAY% !LIVE_TIME!] [BACKGROUND] Router keep-alive packet verified on 192.168.1.10. >> "%LOG_FILE%"
        ) else if !bgIndex! EQU 4 (
            echo [%TODAY% !LIVE_TIME!] [BACKGROUND] Periodic health check successful for host 192.168.1.10. >> "%LOG_FILE%"
        ) else (
            echo [%TODAY% !LIVE_TIME!] [BACKGROUND] System telemetry sync completed for node 192.168.1.10. >> "%LOG_FILE%"
        )
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
echo      INCIDENT INVESTIGATION CAPTURE GAME
echo ========================================================
echo Use 'findstr' mentally or in another window to investigate!
echo.

:: Question 1 Loop (Stays here until answered correctly)
:ASK_Q1
set /p "ans1=Q1: Who is the legit user mentioned in the logs? "
if /i "%ans1%"=="evildeathlove" (
    echo [+] Correct! evildeathlove is authorized.
    echo.
   goto ASK_Q2
) else (
    echo [-] Incorrect. Try again! (Hint: Look for AUTH_SUCCESS and common names)
    echo.
    goto ASK_Q1
)

:: Question 2 Loop (Stays here until answered correctly)
:ASK_Q2
set /p "ans2=Q2: What IP address belongs to the malicious attacker? "
if "%ans2%"=="203.0.113.1" (
    echo [+] Correct! 203.0.113.1 is external and flagged.
    echo.
    goto ASK_Q3
) else (
    echo [-] Incorrect. Try again! (Hint: Look for external ranges like 203.0.xx.xx)
    echo.
    goto ASK_Q2
)

:: Question 3 Loop (Stays here until answered correctly)
:ASK_Q3
set /p "ans2=Q2: What IP address belongs to the IOC? "
if "%ans2%"=="203.0.113.99" (
    echo [+] Correct! 203.0.113.99 is external and flagged.
    echo.
    goto ASK_Q4
) else (
    echo [-] Incorrect. Try again! (Hint: Look for external ranges like 203.0.xx.xx)
    echo.
    goto ASK_Q3
)

:: Question 4 Loop (Stays here until answered correctly)
:ASK_Q4
set /p "ans4=Q4:  Which account successfully logged in according to the AUTH_SUCCESS entry? "
if /i "%ans4%"=="admin123" (
    echo [+]  Correct! The account that successfully logged in was admin123.
    echo.
    goto ASK_Q5
) else (
    echo [-] Incorrect. Try again! (Hint: Search the log for 'AUTH_SUCCESS' and identify the username.)
    echo.
    goto ASK_Q4
)
:: Question 5 Loop (Stays here until answered correctly)
:ASK_Q5
set /p "ans5=Q5: What file was modified by the suspicious activity?"
if /i "%ans5%"=="password.txt" (
    echo [+]  Correct! You identified the modified file: password.txt
    echo.
    goto ASK_Q6
) else (
    echo [-] Incorrect. Try again! (Hint: Search 'ACTIVITY' entries for signs of a file being modified.)
    echo.
    goto ASK_Q5
)
:: Question 6 Loop (Stays here until answered correctly)
:ASK_Q6
set /p "ans6=Q6: What hidden message flag did the attacker drop? "
if /i "%ans6%"=="FLAG{BRuT3-F0rC3-Att5cK}" (
    echo [+] Correct! You successfully extracted the flag!
    echo.
    goto ASK_F
) else (
    echo [-] Incorrect. Try again! (Hint: Look for payloads containing 'FLAG')
    echo.
    goto ASK_Q6
)
:ASK_F
echo ========================================================
echo Investigation Complete! 
echo Tip: You can type 'findstr /i "keyword" %LOG_FILE%' in a separate 
echo command prompt window to inspect the raw data anytime.
echo ========================================================
pause
goto MENU
