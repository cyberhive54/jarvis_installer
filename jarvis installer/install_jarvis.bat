@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo       J.A.R.V.I.S Smart Installer
echo ===========================================
echo.

:: Function to check Python version
echo Checking Python 3.10 installation...
set PYTHON_VERSION=none
for /f "delims=" %%v in ('py -3.10 --version 2^>nul') do (
    echo Detected Python %%v
    set PYTHON_VERSION=%%v
)

if "!PYTHON_VERSION!"=="none" (
    echo ERROR: Python 3.10 is not installed. Please install it to proceed.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo Python 3.10 check: PASSED
echo.

:: Check if Git is installed (optional)
echo Checking Git installation...
set GIT_AVAILABLE=0
git --version >nul 2>&1 && set GIT_AVAILABLE=1

if !GIT_AVAILABLE!==1 (
    echo Git check: PASSED - Will use Git for faster cloning
) else (
    echo Git not found - Will download ZIP file instead
)
echo.

:: Determine architecture
set ARCHITECTURE=32
echo Checking system architecture...
if "!PROCESSOR_ARCHITECTURE!"=="AMD64" set ARCHITECTURE=64
echo Detected !ARCHITECTURE!-bit architecture.
echo.

:: Select installation directory
echo Selecting installation directory...
echo Please select a folder in the dialog box that will open...
echo.

:: Create a temp PowerShell script to get the directory
echo Add-Type -AssemblyName System.Windows.Forms > temp_folder_select.ps1
echo $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog >> temp_folder_select.ps1
echo $folderBrowser.Description = "Select installation directory for J.A.R.V.I.S" >> temp_folder_select.ps1
echo $folderBrowser.ShowNewFolderButton = $true >> temp_folder_select.ps1
echo $folderBrowser.SelectedPath = [System.IO.Directory]::GetCurrentDirectory() >> temp_folder_select.ps1
echo if($folderBrowser.ShowDialog() -eq 'OK'){ >> temp_folder_select.ps1
echo     Write-Output $folderBrowser.SelectedPath >> temp_folder_select.ps1
echo } else { >> temp_folder_select.ps1
echo     Write-Output "CANCELLED" >> temp_folder_select.ps1
echo } >> temp_folder_select.ps1

set "INSTALL_DIR="
for /f "usebackq delims=" %%i in (`powershell -ExecutionPolicy Bypass -File temp_folder_select.ps1 2^>nul`) do set INSTALL_DIR=%%i

:: Clean up temp file
del temp_folder_select.ps1 >nul 2>&1

echo Debug: INSTALL_DIR variable = !INSTALL_DIR!
echo.

if "!INSTALL_DIR!"=="CANCELLED" (
    echo No directory selected cancelled by user.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)

if "!INSTALL_DIR!"=="" (
    echo ERROR: No directory selected or PowerShell error.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)

echo Selected installation directory: !INSTALL_DIR!
echo Directory selection: PASSED
echo.

echo DEBUG: About to start Options GUI section
echo DEBUG: INSTALL_DIR = !INSTALL_DIR!
echo.

:: Options GUI
echo Showing installation options...
echo Please select your preferred option in the dialog box...
echo.

:: Create a temp PowerShell script for options
echo Add-Type -AssemblyName System.Windows.Forms > temp_options.ps1
echo $form = New-Object System.Windows.Forms.Form >> temp_options.ps1
echo $rb1 = New-Object System.Windows.Forms.RadioButton >> temp_options.ps1
echo $rb2 = New-Object System.Windows.Forms.RadioButton >> temp_options.ps1
echo $rb3 = New-Object System.Windows.Forms.RadioButton >> temp_options.ps1
echo $btn = New-Object System.Windows.Forms.Button >> temp_options.ps1
echo $form.Text = 'JARVIS Installer Options' >> temp_options.ps1
echo $form.Size = New-Object System.Drawing.Size(350,250) >> temp_options.ps1
echo $form.StartPosition = 'CenterScreen' >> temp_options.ps1
echo $rb1.Text = 'Run JARVIS After Install' >> temp_options.ps1
echo $rb1.Location = New-Object System.Drawing.Point(50,30) >> temp_options.ps1
echo $rb1.Size = New-Object System.Drawing.Size(250,20) >> temp_options.ps1
echo $rb2.Text = 'Delete Installer After Install' >> temp_options.ps1
echo $rb2.Location = New-Object System.Drawing.Point(50,60) >> temp_options.ps1
echo $rb2.Size = New-Object System.Drawing.Size(250,20) >> temp_options.ps1
echo $rb3.Text = 'Just Install and Exit' >> temp_options.ps1
echo $rb3.Checked = $true >> temp_options.ps1
echo $rb3.Location = New-Object System.Drawing.Point(50,90) >> temp_options.ps1
echo $rb3.Size = New-Object System.Drawing.Size(250,20) >> temp_options.ps1
echo $btn.Text = 'Continue' >> temp_options.ps1
echo $btn.Location = New-Object System.Drawing.Point(135,150) >> temp_options.ps1
echo $btn.Size = New-Object System.Drawing.Size(80,30) >> temp_options.ps1
echo $btn.Add_Click({$form.DialogResult = 'OK'; $form.Close()}) >> temp_options.ps1
echo $form.Controls.AddRange(@($rb1, $rb2, $rb3, $btn)) >> temp_options.ps1
echo $form.Add_Shown({$form.Activate()}) >> temp_options.ps1
echo $result = $form.ShowDialog() >> temp_options.ps1
echo if($result -eq 'OK'){ >> temp_options.ps1
echo     if($rb1.Checked){ exit 1 } >> temp_options.ps1
echo     elseif($rb2.Checked){ exit 2 } >> temp_options.ps1
echo     else { exit 3 } >> temp_options.ps1
echo } else { exit 4 } >> temp_options.ps1

powershell -ExecutionPolicy Bypass -File temp_options.ps1 2>nul
set OPTION=%errorlevel%

:: Clean up temp file
del temp_options.ps1 >nul 2>&1

echo Debug: OPTION selected = !OPTION!
if !OPTION!==4 (
    echo Installation cancelled by user.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
if !OPTION!==5 (
    echo ERROR: Options dialog failed to open.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo Options selection: PASSED
echo.

:: Download J.A.R.V.I.S repository
echo Downloading J.A.R.V.I.S repository...
echo Target directory: !INSTALL_DIR!\J.A.R.V.I.S
echo.

if !GIT_AVAILABLE!==1 (
    echo Using Git to clone repository...
    git clone https://github.com/cyberhive54/J.A.R.V.I.S.git "!INSTALL_DIR!\J.A.R.V.I.S" || (
        echo ERROR: Git clone failed. Trying ZIP download...
        goto :zip_download
    )
    echo Repository cloning: PASSED
) else (
    :zip_download
    echo Downloading ZIP file from GitHub...
    powershell -Command "try { Invoke-WebRequest -Uri 'https://github.com/cyberhive54/J.A.R.V.I.S/archive/refs/heads/main.zip' -OutFile 'jarvis_temp.zip' -ErrorAction Stop } catch { exit 1 }" || (
        echo ERROR: Failed to download repository ZIP file.
        echo Please check your internet connection.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    echo ZIP download: PASSED
    
    echo Extracting repository...
    powershell -Command "try { Expand-Archive -Path 'jarvis_temp.zip' -DestinationPath 'temp_extract' -Force -ErrorAction Stop } catch { exit 1 }" || (
        echo ERROR: Failed to extract ZIP file.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    
    echo Moving files to target directory...
    move "temp_extract\J.A.R.V.I.S-main" "!INSTALL_DIR!\J.A.R.V.I.S" || (
        echo ERROR: Failed to move extracted files.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    
    :: Clean up temporary files
    del jarvis_temp.zip >nul 2>&1
    rd /s /q temp_extract >nul 2>&1
    
    echo Repository extraction: PASSED
)
echo.

echo Changing to installation directory...
cd /d "!INSTALL_DIR!\J.A.R.V.I.S" || (
    echo ERROR: Failed to change to installation directory.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo Directory change: PASSED
echo.

:: Setup and activate virtual environment
echo Setting up virtual environment...
py -3.10 -m venv venv || (
    echo ERROR: Failed to create virtual environment.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo Virtual environment creation: PASSED
echo.

echo Activating virtual environment...
call ".\venv\Scripts\activate.bat" || (
    echo ERROR: Failed to activate virtual environment.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo Virtual environment activation: PASSED
echo.

:: Upgrade pip, setuptools, and wheel
echo Upgrading pip, setuptools, and wheel...
python -m pip install --upgrade pip setuptools wheel || (
    echo WARNING: Error upgrading pip, setuptools, and wheel. Continuing...
)
echo Pip upgrade: COMPLETED
echo.

:: Install required packages
echo Installing required packages from requirements.txt...
python -m pip install -r requirements.txt || (
    echo ERROR: Failed to install requirements.
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo Requirements installation: PASSED
echo.

echo Installing qrcode[pil]...
python -m pip install qrcode[pil] || (
    echo ERROR: Failed to install qrcode[pil].
    echo Exiting in 5 seconds...
    timeout /t 5 /nobreak >nul
    exit /b 1
)
echo QRCode installation: PASSED
echo.

:: Install PyAudio based on architecture
if "!ARCHITECTURE!"=="64" (
    echo Installing PyAudio 64-bit...
    echo PyAudio file: %~dp0pyaudio\PyAudio-0.2.11-cp310-cp310-win_amd64.whl
    python -m pip install "%~dp0pyaudio\PyAudio-0.2.11-cp310-cp310-win_amd64.whl" || (
        echo ERROR: Failed to install PyAudio 64-bit.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    echo PyAudio 64-bit installation: PASSED
    echo.
    
    echo Copying portaudio.dll...
    echo Source: %~dp0portaudio\portaudio.dll
    echo Target: .\venv\Lib\site-packages\
    copy /Y "%~dp0portaudio\portaudio.dll" ".\venv\Lib\site-packages\" || (
        echo ERROR: Failed to copy portaudio.dll.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    echo PortAudio DLL copy: PASSED
) else (
    echo Installing PyAudio 32-bit...
    echo PyAudio file: %~dp0pyaudio\PyAudio-0.2.11-cp310-cp310-win32.whl
    python -m pip install "%~dp0pyaudio\PyAudio-0.2.11-cp310-cp310-win32.whl" || (
        echo ERROR: Failed to install PyAudio 32-bit.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    echo PyAudio 32-bit installation: PASSED
    echo.
    
    echo Copying portaudio_.dll...
    echo Source: %~dp0portaudio\portaudio_.dll
    echo Target: .\venv\Lib\site-packages\
    copy /Y "%~dp0portaudio\portaudio_.dll" ".\venv\Lib\site-packages\" || (
        echo ERROR: Failed to copy portaudio_.dll.
        echo Exiting in 5 seconds...
        timeout /t 5 /nobreak >nul
        exit /b 1
    )
    echo PortAudio DLL copy: PASSED
)
echo.

:: Create start_jarvis.bat if it doesn't exist
if not exist "start_jarvis.bat" (
    echo Creating start_jarvis.bat...
    echo @echo off > start_jarvis.bat
    echo cd /d "%~dp0" >> start_jarvis.bat
    echo call ".\venv\Scripts\activate.bat" >> start_jarvis.bat
    echo python JARVIS.py >> start_jarvis.bat
    echo pause >> start_jarvis.bat
)

:: Post-installation options
if !OPTION!==1 (
    echo Running JARVIS...
    start "" cmd /c "!INSTALL_DIR!\J.A.R.V.I.S\start_jarvis.bat"
)

echo Installation complete!

if !OPTION!==2 (
    echo Deleting installer in 3 seconds...
    timeout /t 3 /nobreak >nul
    cd /d \
    rd /s /q "%~dp0"
) else (
    pause
)
