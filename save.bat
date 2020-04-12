@REM @Author: CPS
@REM @Date:   2019-12-11 23:42:17
@REM @Last Modified by:   CPS
@REM Modified time: 2019-12-12 00:06:13


@echo off
@for /f "delims=/ tokens=1-3" %%a in ("%date:~0,10%") do (call set "newDate=%%a%%b%%c")
@for /f "tokens=* delims= " %%a in ("%time:~0,5%") do (for /f "tokens=1,2 delims=:" %%i in ("%%a") do (call set "newTime=%%i:%%j"))

git add .

@if "%1%"=="" (goto save)
set "ip=%1%"
@set "saveName=[%ip%]-%newDate%-%newTime%"

git commit -m %saveName%
git push -u save master -f
goto end

:save
git commit -m "[Fast Save] %DATE%-%time%"
git push -u save master -f

:end
exit