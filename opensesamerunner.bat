@echo off
title Getting Medialabs subjectID and running an opensesame experiment!
:Go to Bat's Directory - useful for running with Admin rigths under UAC
%~d0
cd%~p0
IF EXIST %~dp0study.txt GOTO StudyFound
	ECHO Study.txt file not found in scripts folder. Aborting...
   pause
   exit
:StudyFound
for /f "tokens=1*delims=:" %%i in (study.txt) do if "%%i"=="Study" set studypath=%%j
for /f "tokens=1*delims=:" %%i in (study.txt) do if "%%i"=="Data" set datapath=%%j
for /f "tokens=1*delims=:" %%i in (study.txt) do if "%%i"=="OpenSesame" set OSPath=%%j
for /f "tokens=1*delims=:" %%i in (study.txt) do if "%%i"=="MedialabSubject" set MLPath=%%j

:CheckStudy
IF EXIST "%studypath%" GOTO CheckOpenSesame
   echo Study file not found. Check reference in study.txt
   pause
   exit
:CheckOpenSesame
IF EXIST "%OSPath%" GOTO CheckML
   echo OpenSesameRun.exe not found. Check reference in study.txt
   pause
   exit
:CheckML
IF EXIST "%MLPath%" GOTO CheckData
   echo Medialab Current Subject Info not found. Check reference in study.txt
   pause
   exit
:CheckData
   IF EXIST %datapath%NUL GOTO GetSubjInfo
   cd\
   md %datapath%
   echo Could not locate data path. New folder created at %datapath%. If this isn't the first run of this particular experiment check reference in study.txt.
 
:GetSubjInfo
  set /p MLSubjectInfo=< %MLPath%
  set snr=%MLSubjectInfo:~10%
 
:CheckForExistingSubjectID 
IF NOT EXIST %datapath%%snr%.csv GOTO GoodToGo
   echo Data for subjectID %snr% already exists.
   ECHO Aborting...
   pause
   exit 
   
:GoodToGo
::echo study path is %studypath%
::echo data path is %datapath%, subject ID will be apended to the CSV file.
::echo OpenSesame is in %OSPath%
::echo Medialab Current Subject Info is in %MLPath%
::echo SubjectID is %snr%

"%OSPath%" "%studypath%" --subject=%snr% --logfile="%datapath%%snr%.csv" --fullscreen


