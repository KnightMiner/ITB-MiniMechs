@echo off

IF EXIST build RMDIR /q /s build
IF EXIST "Mini-Mechs-#.#.#.zip" DEL "Mini-Mechs-#.#.#.zip"
MKDIR build
MKDIR build\MiniMechs

REM Copy required files into build directory
XCOPY img build\MiniMechs\img /s /e /i
XCOPY scripts build\MiniMechs\scripts /s /e /i

REM Zipping contents
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('build', 'Mini-Mechs-#.#.#.zip'); }"

REM Removing build directory
RMDIR /q /s build
