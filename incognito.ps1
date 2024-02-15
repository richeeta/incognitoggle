# Enable/Disable Browser Incognito Functionality on Windows
# Author: Richard Im (@richeeta)
# 
# NOTE: Must be run with Administrator permissions or in a high-privilege shell.

function Invoke-RegistryAction {
    param (
        [string]$browser,
        [scriptblock]$actionBlock,
        [string]$successMessage,
        [string]$errorMessage
    )
    try {
        Write-Host "Processing $browser..."
        & $actionBlock
        Write-Host $successMessage
    }
    catch {
        Write-Host "${errorMessage}: $_"
    }
}

# Disables browser mode based on the browser argument
function Disable-BrowserMode {
    param ([string]$browser)
    Invoke-RegistryAction -browser $browser -actionBlock {
        switch ($browser) {
            "chrome" {
                $path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
                New-ItemProperty -Path $path -Name "IncognitoModeAvailability" -Value 1 -PropertyType DWord -Force
            }
            "edge" {
                $path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
                New-ItemProperty -Path $path -Name "InPrivateModeAvailability" -Value 1 -PropertyType DWord -Force
            }
            "firefox" {
                $path = "HKLM:\SOFTWARE\Policies\Mozilla\Firefox"
                New-ItemProperty -Path $path -Name "DisablePrivateBrowsing" -Value 1 -PropertyType DWord -Force
            }
        }
    } -successMessage "SUCCESS: Disabled $browser mode." -errorMessage "ERROR: Could not disable $browser mode"
}

# Enables browser mode based on the browser argument
function Enable-BrowserMode {
    param ([string]$browser)
    Invoke-RegistryAction -browser $browser -actionBlock {
        switch ($browser) {
            "chrome" {
                $path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
                Remove-ItemProperty -Path $path -Name "IncognitoModeAvailability" -ErrorAction SilentlyContinue
            }
            "edge" {
                $path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
                Remove-ItemProperty -Path $path -Name "InPrivateModeAvailability" -ErrorAction SilentlyContinue
            }
            "firefox" {
                $path = "HKLM:\SOFTWARE\Policies\Mozilla\Firefox"
                Remove-ItemProperty -Path $path -Name "DisablePrivateBrowsing" -ErrorAction SilentlyContinue
            }
        }
    } -successMessage "SUCCESS: Enabled $browser mode." -errorMessage "ERROR: Could not enable $browser mode"
}

# Checks the browser mode status based on the browser argument
function Check-BrowserMode {
    param ([string]$browser)
    switch ($browser) {
        "chrome" {
            $path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
            $propertyName = "IncognitoModeAvailability"
        }
        "edge" {
            $path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
            $propertyName = "InPrivateModeAvailability"
        }
        "firefox" {
            $path = "HKLM:\SOFTWARE\Policies\Mozilla\Firefox"
            $propertyName = "DisablePrivateBrowsing"
        }
    }

    Write-Host "Checking $browser mode status..."
    if (Test-Path $path) {
        try {
            $value = Get-ItemPropertyValue -Path $path -Name $propertyName -ErrorAction Stop
            if ($value -eq 1) {
                Write-Host "$browser mode is DISABLED."
            } else {
                Write-Host "$browser mode is ENABLED."
            }
        } catch {
            Write-Host "$browser mode is not explicitly configured (may be ENABLED by default)."
        }
    } else {
        Write-Host "$browser policies are not configured."
    }
}





# Shows help information
function Show-Help {
    Write-Host "Usage: .\incognito.ps1 [-d|--disable] [-e|--enable] [-c|--check] [chrome,edge,firefox] [-h|--help]
    -d, --disable    Disable specified browser modes.
    -e, --enable     Enable specified browser modes.
    -c, --check      Check if specified browser modes are enabled or disabled.
    -h, --help       Show this help message."
}

# Main logic to parse command-line arguments and call the appropriate function
$action = $null
$browsers = @()

foreach ($arg in $args) {
    switch -Regex ($arg) {
        "^--?d(isable)?$" { $action = "Disable-BrowserMode" }
        "^--?e(nable)?$"  { $action = "Enable-BrowserMode" }
        "^--?c(heck)?$"   { $action = "Check-BrowserMode" }
        "^--?h(elp)?$"    { Show-Help; return }
        "chrome|edge|firefox" { $browsers += $arg }
    }
}

if (-not $action) {
    Show-Help
    return
}

if ($browsers.Count -eq 0) { $browsers = @("chrome", "edge", "firefox") }

foreach ($browser in $browsers) {
    & $action $browser
}
