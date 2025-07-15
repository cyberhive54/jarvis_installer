# J.A.R.V.I.S Smart Installer Documentation

## Overview
The J.A.R.V.I.S Smart Installer is an automated installation tool that sets up J.A.R.V.I.S (Just A Rather Very Intelligent System) on Windows systems. It handles all dependencies, virtual environment setup, and configuration automatically.

## System Requirements

### Operating System
- **Windows 10 or Windows 11** (64-bit or 32-bit)
- **PowerShell 5.1 or later** (usually pre-installed)

### Pre-requisites (Must be installed before running the installer)

#### 1. Python 3.10
- **Download**: [Python 3.10.x from python.org](https://www.python.org/downloads/release/python-3100/)
- **Installation**: 
  - Download the Windows installer (x86-64 for 64-bit, x86 for 32-bit)
  - Run the installer
  - ✅ **IMPORTANT**: Check "Add Python to PATH" during installation
  - Verify installation by opening Command Prompt and typing: `py -3.10 --version`

#### 2. Git for Windows (Optional but Recommended)
- **Download**: [Git for Windows](https://git-scm.com/download/win)
- **Installation**: 
  - Download the installer
  - Run with default settings
  - Verify installation by opening Command Prompt and typing: `git --version`
- **Note**: If Git is not installed, the installer will automatically download the repository as a ZIP file

## Required Files in Installer Folder

The installer folder must contain the following files for complete functionality:

### Core Files
```
jarvis installer/
├── install_jarvis.bat          # Main installer script
├── README.md                   # This documentation
└── pyaudio
|    ├── PyAudio-0.2.11-cp310-cp310-win_amd64.whl    # PyAudio for 64-bit
|    └──PyAudio-0.2.11-cp310-cp310-win32.whl        # PyAudio for 32-bit
└── portaudio/
    ├── portaudio.dll           # PortAudio library for 64-bit
     portaudio_.dll          # PortAudio library for 32-bit
```

### Where to Get Missing Files

#### PyAudio Wheel Files
- **64-bit**: [PyAudio-0.2.11-cp310-cp310-win_amd64.whl](https://pypi.org/project/PyAudio/#files)
- **32-bit**: [PyAudio-0.2.11-cp310-cp310-win32.whl](https://pypi.org/project/PyAudio/#files)

#### PortAudio DLL Files
- Download from [PortAudio official website](http://www.portaudio.com/download.html)
- Or extract from existing PyAudio installation
- Place in `portaudio/` subfolder within installer directory

## Installation Instructions

### Step 1: Prepare the Installer
1. Ensure all required files are in the installer folder
2. Verify Python 3.10 and Git are installed on the target system
3. Right-click on the installer folder and select "Run as administrator" (optional but recommended)

### Step 2: Run the Installer
1. Double-click `install_jarvis.bat` or run it from Command Prompt
2. The installer will automatically check system requirements
3. Follow the GUI prompts:
   - **Directory Selection**: Choose where to install J.A.R.V.I.S
   - **Installation Options**: Select your preferred post-install action

### Step 3: Installation Process
The installer will automatically:
1. ✅ Verify Python 3.10 installation
2. ✅ Check Git availability (optional)
3. ✅ Detect system architecture (32-bit/64-bit)
4. ✅ Download J.A.R.V.I.S repository (Git clone or ZIP download)
5. ✅ Create Python virtual environment
6. ✅ Install all required dependencies
7. ✅ Configure PyAudio with appropriate architecture
8. ✅ Create launch script (`start_jarvis.bat`)

## Installation Options

During installation, you can choose from:

### Option 1: Run JARVIS After Install
- Automatically launches J.A.R.V.I.S after installation completes
- Opens in a new terminal window
- Recommended for immediate testing

### Option 2: Delete Installer After Install
- Removes the installer folder after successful installation
- Saves disk space
- Use only if you don't need to reinstall later

### Option 3: Just Install and Exit (Default)
- Completes installation and exits
- Keeps installer folder intact
- Recommended for most users

## Post-Installation

### Running J.A.R.V.I.S
After installation, you can run J.A.R.V.I.S using:
- **GUI Method**: Double-click `start_jarvis.bat` in the installation folder
- **Command Line**: Navigate to installation folder and run `start_jarvis.bat`

### File Structure After Installation
```
J.A.R.V.I.S/
├── JARVIS.py                   # Main application
├── JarvisUi.py                 # GUI interface
├── requirements.txt            # Python dependencies
├── venv/                       # Virtual environment
├── start_jarvis.bat           # Launch script
└── [other project files]
```

## Troubleshooting

### Common Issues

#### "Python 3.10 is not installed"
- **Solution**: Install Python 3.10 from python.org
- **Note**: Make sure to add Python to PATH during installation

#### "Failed to download repository"
- **Solution**: Check your internet connection
- **Note**: The installer will try Git first, then fallback to ZIP download
- **Alternative**: Install Git for Windows for faster cloning

#### "Failed to install PyAudio"
- **Solution**: Ensure PyAudio wheel files are in the installer folder
- **Check**: Verify correct architecture (32-bit vs 64-bit)

#### "No directory selected"
- **Solution**: Make sure to select a folder in the dialog box
- **Note**: The installer needs write permissions to the selected directory

#### "Access denied" errors
- **Solution**: Run the installer as administrator
- **Alternative**: Choose a different installation directory

### Installation Logs
The installer provides detailed logging during the process:
- Each step shows "PASSED" or error messages
- Errors include 5-second countdown for reading
- Debug information shows selected directories and options

## Advanced Configuration

### Custom Installation Location
- The installer can install J.A.R.V.I.S anywhere on your system
- Recommended locations:
  - `C:\Users\[Username]\Documents\J.A.R.V.I.S`
  - `C:\J.A.R.V.I.S`
  - `D:\Applications\J.A.R.V.I.S`

### Network Requirements
- **Internet connection required** for:
  - Cloning repository from GitHub
  - Downloading Python packages
  - Updating pip and setuptools

### Firewall/Antivirus
- Some antivirus software may flag the installer
- Add exception for the installer folder if needed
- Windows Defender may require approval for network access

## Uninstallation

To remove J.A.R.V.I.S:
1. Delete the installation folder
2. No system-wide changes are made
3. Python and Git remain installed for other applications

## Support and Updates

### Getting Help
- Check the troubleshooting section first
- Verify all pre-requisites are met
- Ensure all required files are in the installer folder

### Updates
- To update J.A.R.V.I.S, run the installer again
- Choose the same installation directory
- The installer will overwrite existing files

## Technical Details

### Dependencies Installed
The installer automatically installs 78+ Python packages including:
- SpeechRecognition for voice input
- PyQt5 for GUI interface
- OpenCV for computer vision
- Requests for web interactions
- And many more...

### Architecture Detection
- Automatically detects 32-bit vs 64-bit Windows
- Installs appropriate PyAudio version
- Configures PortAudio libraries correctly

### Virtual Environment
- Creates isolated Python environment
- Prevents conflicts with system Python
- All dependencies installed locally

## Security Notes

- The installer does not modify system files
- All installations are local to the selected directory
- No administrator privileges required (recommended though)
- No data is transmitted except for package downloads

## Version Information

- **Installer Version**: 1.0
- **Compatible with**: J.A.R.V.I.S from GitHub repository
- **Python Version**: 3.10.x required
- **Supported OS**: Windows 10/11 (32-bit and 64-bit)

---

**Note**: This installer is designed to work with the J.A.R.V.I.S project available at `https://github.com/cyberhive54/J.A.R.V.I.S.git`. Ensure you have the correct repository URL and all required files before running the installer.
