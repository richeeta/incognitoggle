# Browser Incognito Mode Management Script

**Author:** Richard Im (@richeeta)

## Description

This PowerShell script allows Administrators to easily enable, disable, or check the status of the incognito/private browsing modes for Google Chrome, Microsoft Edge, and Mozilla Firefox on a Windows system.

## Features

- **Disable Browser Modes**: Prevent users from using private browsing/incognito modes.
- **Enable Browser Modes**: Allow users to use private browsing/incognito modes.
- **Check Browser Mode Status**: Check if a browser's private browsing/igcognito mode is enabled or disabled.

## Usage

To use this script, you must have administrative privileges on your Windows system.

**Disable Browser Modes** (`-d|--disable`): Disables the incognito/private mode for specified browsers. (Defaults to `all` without arguments.)
```powershell
.\incognito.ps1 -d
.\incognito.ps1 --disable [chrome|edge|firefox|all]
```

**Enable Browser Modes** (`-e|--enable`): Enables the incognito/private mode for specified browsers. (Defaults to `all` without arguments.)
```powershell
.\incognito.ps1 -e
.\incognito.ps1 --enable [chrome|edge|firefox|all]
```

**Check Browser Mode Status** (`-c|--check`): Checks whether the incognito/private mode is enabled or disabled for specified browsers. (Defaults to `all` without arguments.)
```powershell
.\incognito.ps1 -c
.\incognito.ps1 --check [chrome|edge|firefox|all]
```

**Help**: Displays usage information.
```powershell
.\incognito.ps1 -h

Usage: .\incognito.ps1 [-d|--disable] [-e|--enable] [-c|--check] [chrome,edge,firefox] [-h|--help]
    -d, --disable    Disable specified browser modes.
    -e, --enable     Enable specified browser modes.
    -c, --check      Check if specified browser modes are enabled or disabled.
    -h, --help       Show this help message.
```

## Requirements

* Windows PowerShell 5.1 or higher.
* Administrative privileges on the system where the script is executed.
