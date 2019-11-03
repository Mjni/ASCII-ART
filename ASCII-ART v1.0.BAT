@Echo off
chcp 65001 >nul
Title ASCII-ART
Setlocal enabledelayedexpansion
if not exist Canvas\ md Canvas

REM █████████████████████
REM ██  ASCII-ART.BAT  ██
REM ██    Mjni#3250    ██
REM █████████████████████

:Dimesions
Echo.
Echo [Dimensions]
Echo.
:Columns
Set /P Columns=Columns:
if !Columns! gtr 50 (
	Echo Maximum amount of Columns is 50
	Pause >nul
	goto :Columns
)
if !Columns! lss 3 (
	Echo Minimum amount of Columns is 3
	Pause >nul
	goto :Columns
)
Echo.
:Lines
Set /P Lines=Lines:
if !Lines! gtr 50 (
	Echo Maximum amount of Lines is 50
	Pause >nul
	goto :Lines
)
if !Lines! lss 3 (
	Echo Minimum amount of Lines is 3
	Pause >nul
	goto :Lines
)




cd Canvas\
if exist !Lines!x!Columns!.bat goto :DisplayPrepare
setlocal disabledelayedexpansion
Set ForLines=0
break>%Lines%x%Columns%.bat
:ForLines
IF %ForLines% equ %Lines% goto :DisplayPrepare
Echo. >> %Lines%x%Columns%.bat 
Echo|set /p="Echo." >> %Lines%x%Columns%.bat
Set /a ForLines+=1
cls
Echo.
Echo [Generating]
Echo.
Echo %ForLines% \ %Lines%
Set ForColumns=0
:ForColumns
IF %ForColumns% equ %Columns% (
goto :ForLines
)
Set /a ForColumns+=1
Echo|set /p="!%ForLines%.%ForColumns%!" >> %Lines%x%Columns%.bat
goto :ForColumns





:DisplayPrepare
setlocal enabledelayedexpansion
Set /a ColumnMode=!Columns!+2
Set /a LineMode=!Lines!+4
if !ColumnMode! LSS 33 set ColumnMode=35
mode con: cols=!ColumnMode! lines=!LineMode!
Set Bx=3
Set By=3
Set ForLineVar=0
for /l %%A in (1,1,!Lines!) do (
Set /a ForLineVar+=1
Set ForColumnVar=0
for /l %%A in (1,1,!Columns!) do (
Set /a ForColumnVar+=1
Set !ForLineVar!.!ForColumnVar!=.
)
)
set Border=------------------------------------------------------------
set Brush=#
set size=1
set help=0






:Display
set Obr=!%By%.%Bx%!
set !By!.!Bx!=+
if !By! LSS 10 (
Set y0=0
) else (
set y0=
)
if !Bx! LSS 10 (
Set x0=0
) else (
set x0=
)
:DisplayShortcut
cls
Echo [Canvas] Brush:!Brush! Y:!y0!!By! X:!x0!!Bx! 
if !help! equ 0 (
Echo Press H for Help
) else (
Echo.
)
Echo !Border:~0,%Columns%!
call "!Lines!x!Columns!.bat"
choice /C:awsdhcbfq /n /m ""
REM A
if "%errorlevel%" equ "1" (
if !Bx! equ 1 (
set !By!.!Bx!=!Obr!
set /a Bx=!Columns!
goto :Display
)
set !By!.!Bx!=!Obr!
set /a Bx-=1
goto :Display
)
REM W
if "%errorlevel%" equ "2" (
if !By! equ 1 (
set !By!.!Bx!=!Obr!
set /a By=!Lines!
goto :Display
)
set !By!.!Bx!=!Obr!
set /a By=!By!-1
goto :Display
)
REM S
if "%errorlevel%" equ "3" (
if !By! equ !Lines! (
set !By!.!Bx!=!Obr!
set /a By=1
goto :Display
)
set !By!.!Bx!=!Obr!
set /a By=!By!+1
goto :Display
)
REM D
if "%errorlevel%" equ "4" (
if !Bx! equ !Columns! (
set !By!.!Bx!=!Obr!
set /a Bx=1
goto :Display
)
set !By!.!Bx!=!Obr!
set /a Bx+=1
goto :Display
)
REM H
if "%errorlevel%" equ "5" (
if !LineMode! LSS 8 (
mode con: cols=!ColumnMode! lines=9
)
set Help=1
cls
Echo [Help]
Echo.
Echo  Movement: AWSD
Echo  Change-Brush: C
Echo  Draw: B
Echo  Fill: F
Echo  Help: H
pause >nul
mode con: cols=!ColumnMode! lines=!LineMode!
goto :DisplayShortcut
)
REM C
if "%errorlevel%" equ "6" (
if !LineMode! LSS 4 (
mode con: cols=!ColumnMode! lines=5
)
cls
Echo [Brush]
Echo.
Set /p Brush=Brush:
Set Brush=!Brush:~0,1!
goto :DisplayShortcut
)
REM B
if "%errorlevel%" equ "7" (
set !By!.!Bx!=!Brush!
goto :Display
)
REM F
if "%errorlevel%" equ "8" (
	cls
	Echo [Fill]
	Echo.
	Echo Y:!y0!!By! X:!x0!!Bx!
	Echo Point A must Be Closest to top-left.
	Set /p "PointA=Coordinate A(E.g. 10,10):"
	Echo.
	Set /p "PointB=Coordinate B:"
	Set PointA=!PointA:,=!
	Set PointB=!PointB:,=!
	Set /a PointAY=!PointA:~0,2!
	Set /a PointAX=!PointA:~2,4!
	Set /a PointBY=!PointB:~0,2!+1
	Set /a PointBX=!PointB:~2,4!+1
	Set /a PointForX=!PointBX!-!PointAX!
	Set /a PointForY=!PointBY!-!PointAY!
	set X=!PointAX!
	for /l %%A in (1,1,!PointForX!) do (
		Set Y=!PointAY!
		for /l %%A in (1,1,!PointForY!) do (
			Set !X!.!Y!=!Brush!
			Set /a Y+=1
		)
		Set /a X+=1
	)
goto :DisplayShortcut
)
if "%errorlevel%" equ "9" (
cls
Echo Quit [Y/N]
goto :choice
)
goto :Display


:choice
choice /C:YN /n /m ""
if "%errorlevel%" equ "1" (
goto :save
)
if "%errorlevel%" equ "2" (
goto :DisplayShortcut
)


:save
Set /P ArtName=FileName(No Extensions):
if exist ..\!ArtName! (
echo Already Exists
pause >nul
goto :save
) 
cd ..\
(
call "Canvas\!Lines!x!Columns!.bat"
) >> !ArtName!.txt
Echo Saved!
Echo Press any button to quit
pause >nul
endlocal
exit /b 0

