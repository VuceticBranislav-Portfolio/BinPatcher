@echo off
echo Cleaning...
del /f /q /s *.local
del /f /q /s *.identcache
del /f /q /s *.tvsconfig
del /f /q /s *.dcu
del /f /q /s *.stat
del /f /q /s *.map
del /f /q /s *.res
del /f /q /s *.drc
del /f /q /s *.dsk
del /f /q /s *.~dsk
rem for %%i in (*.dsk) do if not "%%i"=="ProjectGroup.dsk" del /f /q /s "%%i"
for /d /r . %%d in ("__history")  do @if exist "%%d" rd /s /q "%%d"
for /d /r . %%d in ("__recovery") do @if exist "%%d" rd /s /q "%%d"
for /d /r . %%d in ("Win32") do @if exist "%%d" rd /s /q "%%d"
for /d /r . %%d in ("Win64") do @if exist "%%d" rd /s /q "%%d"