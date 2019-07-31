@echo off

if /I %1 == build goto :build
if /I %1 == play goto :play

:build
..\bin\zilf.exe %2.zil
..\bin\zapf.exe %2.zap
goto :eof

:play
%2.z3
goto :eof
