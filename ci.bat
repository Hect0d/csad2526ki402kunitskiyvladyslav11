@echo off
rem CI helper for Windows (batch). Runs configure, build, make build.sh executable and run tests.
rem *** NOW USING MinGW Makefiles instead of NMake ***
setlocal
echo.
echo === Create build directory ===
if not exist "build" (
    mkdir "build"
) else (
    echo build directory already exists
)
echo.
echo === Enter build directory ===
pushd build
if errorlevel 1 (
    echo Failed to enter build directory.
    exit /b 1
)
echo.
echo === Configure project with CMake (MinGW Makefiles) ===
cmake -G "MinGW Makefiles" -DCMAKE_SH="CMAKE_SH-NOTFOUND" ..
if errorlevel 1 (
    echo CMake configuration failed.
    popd
    exit /b 1
)
echo.
echo === Build project ===
cmake --build .
if errorlevel 1 (
    echo Build failed.
    popd
    exit /b 1
)
echo.
echo === Grant execution rights to build.sh (if present) ===
rem We're currently in the build directory; target build.sh in repo root as ..\build.sh
where chmod >nul 2>&1
if %ERRORLEVEL%==0 (
    if exist "..\build.sh" (
        chmod +x "..\build.sh" 2>nul || echo chmod returned non-zero exit code
    ) else (
        echo ..\build.sh not found; looking for build.sh in current directory
        if exist "build.sh" (
            chmod +x "build.sh" 2>nul || echo chmod returned non-zero exit code
        ) else (
            echo No build.sh found to chmod.
        )
    )
) else (
    rem If chmod isn't available (plain Windows cmd), try PowerShell icacls as a best-effort
    where powershell >nul 2>&1
    if %ERRORLEVEL%==0 (
        if exist "..\build.sh" (
            powershell -Command "if (Test-Path '..\build.sh') { icacls '..\build.sh' /grant '%USERNAME%':RX }" >nul 2>&1 || echo icacls command returned non-zero exit code
        ) else if exist "build.sh" (
            powershell -Command "if (Test-Path 'build.sh') { icacls 'build.sh' /grant '%USERNAME%':RX }" >nul 2>&1 || echo icacls command returned non-zero exit code
        ) else (
            echo No build.sh found to change permissions.
        )
    ) else (
        echo Neither chmod nor PowerShell available; skipping permission change.
    )
)
echo.
echo === Commit permission change (if any) ===
popd
where git >nul 2>&1
if %ERRORLEVEL%==0 (
    git add build.sh >nul 2>&1
    git commit -m "Make build.sh executable" >nul 2>&1 || echo No changes to commit or commit failed.
) else (
    echo git not found in PATH; skipping git add/commit.
)
echo.
echo === Run tests with CTest ===
pushd build
where ctest >nul 2>&1
if %ERRORLEVEL%==0 (
    ctest --output-on-failure
    if errorlevel 1 (
        echo Some tests failed.
        popd
        exit /b 1
    )
) else (
    echo ctest not found in PATH; skipping tests.
)
popd
echo.
echo === CI script finished successfully ===
endlocal
exit /b 0
