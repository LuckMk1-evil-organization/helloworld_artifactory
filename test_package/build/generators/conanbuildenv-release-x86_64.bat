@echo off
setlocal
echo @echo off > "C:\Users\223083658\Downloads\helloworld_artifactory\test_package\build\generators\deactivate_conanbuildenv-release-x86_64.bat"
echo echo Restoring environment >> "C:\Users\223083658\Downloads\helloworld_artifactory\test_package\build\generators\deactivate_conanbuildenv-release-x86_64.bat"
for %%v in () do (
    set foundenvvar=
    for /f "delims== tokens=1,2" %%a in ('set') do (
        if /I "%%a" == "%%v" (
            echo set "%%a=%%b">> "C:\Users\223083658\Downloads\helloworld_artifactory\test_package\build\generators\deactivate_conanbuildenv-release-x86_64.bat"
            set foundenvvar=1
        )
    )
    if not defined foundenvvar (
        echo set %%v=>> "C:\Users\223083658\Downloads\helloworld_artifactory\test_package\build\generators\deactivate_conanbuildenv-release-x86_64.bat"
    )
)
endlocal

