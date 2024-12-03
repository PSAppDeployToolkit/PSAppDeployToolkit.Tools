<#
    .SYNOPSIS
    PSSCriptAnalyzer rules to check for usage of legacy PSAppDeployToolkit v3 commands or variables.
    .DESCRIPTION
    Can be used directly with PSSCriptAnalyzer or via Test-ADTCompatibility and Convert-ADTDeployment functions.
    .EXAMPLE
    Measure-ADTCompatibility -ScriptBlockAst $ScriptBlockAst
    .INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]
    .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
    .NOTES
    None
#>
function Measure-ADTCompatibility
{
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    Begin
    {
        $variableMappings = @{
            AllowRebootPassThru = '$adtSession.AllowRebootPassThru'
            appArch = '$adtSession.AppArch'
            appLang = '$adtSession.AppLang'
            appName = '$adtSession.AppName'
            appRevision = '$adtSession.AppRevision'
            appScriptAuthor = '$adtSession.AppScriptAuthor'
            appScriptDate = '$adtSession.AppScriptDate'
            appScriptVersion = '$adtSession.AppScriptVersion'
            appVendor = '$adtSession.AppVendor'
            appVersion = '$adtSession.AppVersion'
            currentDate = '$adtSession.CurrentDate'
            currentDateTime = '$adtSession.CurrentDateTime'
            defaultMsiFile = '$adtSession.DefaultMsiFile'
            deployAppScriptDate = '$adtSession.DeployAppScriptDate'
            deployAppScriptFriendlyName = '$adtSession.DeployAppScriptFriendlyName'
            deployAppScriptParameters = '$adtSession.DeployAppScriptParameters'
            deployAppScriptVersion = '$adtSession.DeployAppScriptVersion'
            DeploymentType = '$adtSession.DeploymentType'
            deploymentTypeName = '$adtSession.DeploymentTypeName'
            DeployMode = '$adtSession.DeployMode'
            dirFiles = '$adtSession.DirFiles'
            dirSupportFiles = '$adtSession.DirSupportFiles'
            DisableScriptLogging = '$adtSession.DisableLogging'
            installName = '$adtSession.InstallName'
            installPhase = '$adtSession.InstallPhase'
            installTitle = '$adtSession.InstallTitle'
            logName = '$adtSession.LogName'
            logTempFolder = '$adtSession.LogTempFolder'
            scriptDirectory = '$adtSession.ScriptDirectory'
            TerminalServerMode = '$adtSession.TerminalServerMode'
            useDefaultMsi = '$adtSession.UseDefaultMsi'
            appDeployConfigFile = $null
            appDeployCustomTypesSourceCode = $null
            appDeployExtScriptDate = $null
            appDeployExtScriptFriendlyName = $null
            appDeployExtScriptParameters = $null
            appDeployExtScriptVersion = $null
            appDeployLogoBanner = $null
            appDeployLogoBannerHeight = $null
            appDeployLogoBannerMaxHeight = $null
            appDeployLogoBannerObject = $null
            appDeployLogoIcon = $null
            appDeployLogoImage = $null
            appDeployMainScriptAsyncParameters = $null
            appDeployMainScriptDate = $null
            appDeployMainScriptFriendlyName = $null
            appDeployMainScriptMinimumConfigVersion = $null
            appDeployMainScriptParameters = $null
            appDeployRunHiddenVbsFile = $null
            appDeployToolkitDotSourceExtensions = $null
            appDeployToolkitExtName = $null
            AsyncToolkitLaunch = $null
            BlockExecution = $null
            ButtonLeftText = $null
            ButtonMiddleText = $null
            ButtonRightText = $null
            CleanupBlockedApps = $null
            closeAppsCountdownGlobal = $null
            configBalloonTextComplete = $null
            configBalloonTextError = $null
            configBalloonTextFastRetry = $null
            configBalloonTextRestartRequired = $null
            configBalloonTextStart = $null
            configBannerIconBannerName = $null
            configBannerIconFileName = $null
            configBannerLogoImageFileName = $null
            configBlockExecutionMessage = $null
            configClosePromptButtonClose = $null
            configClosePromptButtonContinue = $null
            configClosePromptButtonContinueTooltip = $null
            configClosePromptButtonDefer = $null
            configClosePromptCountdownMessage = $null
            configClosePromptMessage = $null
            configConfigDate = $null
            configConfigDetails = $null
            configConfigVersion = $null
            configDeferPromptDeadline = $null
            configDeferPromptExpiryMessage = $null
            configDeferPromptRemainingDeferrals = $null
            configDeferPromptWarningMessage = $null
            configDeferPromptWelcomeMessage = $null
            configDeploymentTypeInstall = $null
            configDeploymentTypeRepair = $null
            configDeploymentTypeUnInstall = $null
            configDiskSpaceMessage = $null
            configInstallationDeferExitCode = $null
            configInstallationPersistInterval = $null
            configInstallationPromptToSave = $null
            configInstallationRestartPersistInterval = $null
            configInstallationUIExitCode = $null
            configInstallationUILanguageOverride = $null
            configInstallationUITimeout = $null
            configInstallationWelcomePromptDynamicRunningProcessEvaluation = $null
            configInstallationWelcomePromptDynamicRunningProcessEvaluationInterval = $null
            configMSIInstallParams = $null
            configMSILogDir = $null
            configMSILoggingOptions = $null
            configMSIMutexWaitTime = $null
            configMSISilentParams = $null
            configMSIUninstallParams = $null
            configProgressMessageInstall = $null
            configProgressMessageRepair = $null
            configProgressMessageUninstall = $null
            configRestartPromptButtonRestartLater = $null
            configRestartPromptButtonRestartNow = $null
            configRestartPromptMessage = $null
            configRestartPromptMessageRestart = $null
            configRestartPromptMessageTime = $null
            configRestartPromptTimeRemaining = $null
            configRestartPromptTitle = $null
            configShowBalloonNotifications = $null
            configToastAppName = $null
            configToastDisable = $null
            configToolkitCachePath = $null
            configToolkitCompressLogs = $null
            configToolkitLogAppend = $null
            configToolkitLogDebugMessage = $null
            configToolkitLogDir = $null
            configToolkitLogMaxHistory = $null
            configToolkitLogMaxSize = $null
            configToolkitLogStyle = $null
            configToolkitLogWriteToHost = $null
            configToolkitRegPath = $null
            configToolkitRequireAdmin = $null
            configToolkitTempPath = $null
            configToolkitUseRobocopy = $null
            configWelcomePromptCountdownMessage = $null
            configWelcomePromptCustomMessage = $null
            CountdownNoHideSeconds = $null
            CountdownSeconds = $null
            currentTime = $null
            currentTimeZoneBias = $null
            defaultFont = $null
            deployModeNonInteractive = $null
            deployModeSilent = $null
            DeviceContextHandle = $null
            dirAppDeployTemp = $null
            dpiPixels = $null
            dpiScale = $null
            envOfficeChannelProperty = $null
            envShellFolders = $null
            exeMsiexec = $null
            exeSchTasks = $null
            exeWusa = $null
            ExitOnTimeout = $null
            formattedOSArch = $null
            formWelcomeStartPosition = $null
            GetAccountNameUsingSid = $null
            GetDisplayScaleFactor = $null
            GetLoggedOnUserDetails = $null
            GetLoggedOnUserTempPath = $null
            GraphicsObject = $null
            HKULanguages = $null
            HKUPrimaryLanguageShort = $null
            hr = $null
            Icon = $null
            installationStarted = $null
            InvocationInfo = $null
            invokingScript = $null
            IsOOBEComplete = '(Test-ADTOobeCompleted)'
            IsTaskSchedulerHealthy = $null
            LocalPowerUsersGroup = $null
            LogFileInitialized = $null
            loggedOnUserTempPath = $null
            LogicalScreenHeight = $null
            LogTimeZoneBias = $null
            mainExitCode = $null
            Matches = $null
            Message = $null
            MessageAlignment = $null
            MinimizeWindows = $null
            moduleAppDeployToolkitMain = $null
            msiRebootDetected = $null
            NoCountdown = $null
            notifyIcon = $null
            OldDisableLoggingValue = $null
            oldPSWindowTitle = $null
            PersistPrompt = $null
            PhysicalScreenHeight = $null
            PrimaryWindowsUILanguage = $null
            ProgressRunspace = $null
            ProgressSyncHash = $null
            ReferencedAssemblies = $null
            ReferredInstallName = $null
            ReferredInstallTitle = $null
            ReferredLogName = $null
            regKeyAppExecution = $null
            regKeyApplications = $null
            regKeyDeferHistory = $null
            regKeyLotusNotes = $null
            RevertScriptLogging = $null
            runningProcessDescriptions = $null
            scriptFileName = $null
            scriptName = $null
            scriptParentPath = $null
            scriptPath = $null
            scriptRoot = $null
            scriptSeparator = $null
            ShowBlockedAppDialog = $null
            ShowInstallationPrompt = $null
            ShowInstallationRestartPrompt = $null
            switch = $null
            Timeout = $null
            Title = $null
            TopMost = $null
            TypeDef = $null
            UserDisplayScaleFactor = $null
            welcomeTimer = $null
            xmlBannerIconOptions = $null
            xmlConfig = $null
            xmlConfigFile = $null
            xmlConfigMSIOptions = $null
            xmlConfigUIOptions = $null
            xmlLoadLocalizedUIMessages = $null
            xmlToastOptions = $null
            xmlToolkitOptions = $null
            xmlUIMessageLanguage = $null
            xmlUIMessages = $null
        }

        $functionMappings = @{
            'Write-Log' = @{
                'NewFunction' = 'Write-ADTLogEntry'
                'TransformParameters' = @{
                    'Text' = { "-Message $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'AppendToLogFile'
                    'LogDebugMessage'
                    'MaxLogHistory'
                    'MaxLogFileSizeMB'
                    'WriteHost'
                )
            }
            'Exit-Script' = @{
                'NewFunction' = 'Exit-ADTScript'
            }
            'Invoke-HKCURegistrySettingsForAllUsers' = @{
                'NewFunction' = 'Invoke-ADTAllUsersRegistryAction'
                'TransformParameters' = @{
                    'RegistrySettings' = { "-ScriptBlock $($_.Replace('$UserProfile', '$_'))" }
                }
            }
            'Get-HardwarePlatform' = @{
                'NewFunction' = '$envHardwareType'
                'RemoveParameters' = @(
                    'ContinueOnError'
                )
            }
            'Get-FreeDiskSpace' = @{
                'NewFunction' = 'Get-ADTFreeDiskSpace'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Remove-InvalidFileNameChars' = @{
                'NewFunction' = 'Remove-ADTInvalidFileNameChars'
            }
            'Get-InstalledApplication' = @{
                'NewFunction' = 'Get-ADTApplication'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'Exact' = '-NameMatch Exact' # Should inspect switch values here in case of -Switch:$false
                    'WildCard' = '-NameMatch WildCard' # Should inspect switch values here in case of -Switch:$false
                    'RegEx' = '-NameMatch RegEx' # Should inspect switch values here in case of -Switch:$false
                }
            }
            'Remove-MSIApplications' = @{
                'NewFunction' = 'Uninstall-ADTApplication'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'Exact' = '-NameMatch Exact' # Should inspect switch values here in case of -Switch:$false
                    'WildCard' = '-NameMatch WildCard' # Should inspect switch values here in case of -Switch:$false
                    'Arguments' = { "-ArgumentList $_" }
                    'Parameters' = { "-ArgumentList $_" }
                    'AddParameters' = { "-AdditionalArgumentList $_" }
                    'LogName' = { "-LogFileName $_" }
                    'FilterApplication' = {
                        $filterApplication = @(if ($null -eq $boundParameters.FilterApplication.Value.Extent) { $null } else { $boundParameters.FilterApplication.Value.SafeGetValue() })
                        $excludeFromUninstall = @(if ($null -eq $boundParameters.ExcludeFromUninstall.Value.Extent) { $null } else { $boundParameters.ExcludeFromUninstall.Value.SafeGetValue() })

                        $filterArray = $(
                            foreach ($item in $filterApplication)
                            {
                                if ($null -ne $item)
                                {
                                    if ($item.Count -eq 1 -and $item[0].Count -eq 3) { $item = $item[0] } # Handle the case where input is of the form @(, @('Prop', 'Value', 'Exact'), @('Prop', 'Value', 'Exact'))
                                    if ($item[2] -eq 'RegEx')
                                    {
                                        "`$_.$($item[0]) -match '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Contains')
                                    {
                                        $regEx = [System.Text.RegularExpressions.Regex]::Escape(($item[1] -replace "'", "''")) -replace '(?<!\\)\\ ', ' '
                                        "`$_.$($item[0]) -match '$regEx'"
                                    }
                                    elseif ($item[2] -eq 'WildCard')
                                    {
                                        "`$_.$($item[0]) -like '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Exact')
                                    {
                                        if ($item[1] -is [System.Boolean])
                                        {
                                            "`$_.$($item[0]) -eq `$$($item[1].ToString().ToLower())"
                                        }
                                        else
                                        {
                                            "`$_.$($item[0]) -eq '$($item[1] -replace "'","''")'"
                                        }
                                    }
                                }
                            }
                            foreach ($item in $excludeFromUninstall)
                            {
                                if ($null -ne $item)
                                {
                                    if ($item.Count -eq 1 -and $item[0].Count -eq 3) { $item = $item[0] } # Handle the case where input is of the form @(, @('Prop', 'Value', 'Exact'), @('Prop', 'Value', 'Exact'))
                                    if ($item[2] -eq 'RegEx')
                                    {
                                        "`$_.$($item[0]) -notmatch '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Contains')
                                    {
                                        $regEx = [System.Text.RegularExpressions.Regex]::Escape(($item[1] -replace "'", "''")) -replace '(?<!\\)\\ ', ' '
                                        "`$_.$($item[0]) -notmatch '$regEx'"

                                    }
                                    elseif ($item[2] -eq 'WildCard')
                                    {
                                        "`$_.$($item[0]) -notlike '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Exact')
                                    {
                                        if ($item[1] -is [System.Boolean])
                                        {
                                            "`$_.$($item[0]) -ne `$$($item[1].ToString().ToLower())"
                                        }
                                        else
                                        {
                                            "`$_.$($item[0]) -ne '$($item[1] -replace "'","''")'"
                                        }
                                    }
                                }
                            }
                        )

                        $filterScript = $filterArray -join ' -and '

                        if ($filterScript)
                        {
                            "-FilterScript { $filterScript }"
                        }
                    }
                    'ExcludeFromUninstall' = {
                        $filterApplication = @(if ($null -eq $boundParameters.FilterApplication.Value.Extent) { $null } else { $boundParameters.FilterApplication.Value.SafeGetValue() })
                        $excludeFromUninstall = @(if ($null -eq $boundParameters.ExcludeFromUninstall.Value.Extent) { $null } else { $boundParameters.ExcludeFromUninstall.Value.SafeGetValue() })

                        $filterArray = $(
                            foreach ($item in $filterApplication)
                            {
                                if ($null -ne $item)
                                {
                                    if ($item.Count -eq 1 -and $item[0].Count -eq 3) { $item = $item[0] } # Handle the case where input is of the form @(, @('Prop', 'Value', 'Exact'), @('Prop', 'Value', 'Exact'))
                                    if ($item[2] -eq 'RegEx')
                                    {
                                        "`$_.$($item[0]) -match '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Contains')
                                    {
                                        $regEx = [System.Text.RegularExpressions.Regex]::Escape(($item[1] -replace "'", "''")) -replace '(?<!\\)\\ ', ' '
                                        "`$_.$($item[0]) -match '$regEx'"
                                    }
                                    elseif ($item[2] -eq 'WildCard')
                                    {
                                        "`$_.$($item[0]) -like '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Exact')
                                    {
                                        if ($item[1] -is [System.Boolean])
                                        {
                                            "`$_.$($item[0]) -eq `$$($item[1].ToString().ToLower())"
                                        }
                                        else
                                        {
                                            "`$_.$($item[0]) -eq '$($item[1] -replace "'","''")'"
                                        }
                                    }
                                }
                            }
                            foreach ($item in $excludeFromUninstall)
                            {
                                if ($null -ne $item)
                                {
                                    if ($item.Count -eq 1 -and $item[0].Count -eq 3) { $item = $item[0] } # Handle the case where input is of the form @(, @('Prop', 'Value', 'Exact'), @('Prop', 'Value', 'Exact'))
                                    if ($item[2] -eq 'RegEx')
                                    {
                                        "`$_.$($item[0]) -notmatch '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Contains')
                                    {
                                        $regEx = [System.Text.RegularExpressions.Regex]::Escape(($item[1] -replace "'", "''")) -replace '(?<!\\)\\ ', ' '
                                        "`$_.$($item[0]) -notmatch '$regEx'"

                                    }
                                    elseif ($item[2] -eq 'WildCard')
                                    {
                                        "`$_.$($item[0]) -notlike '$($item[1] -replace "'","''")'"
                                    }
                                    elseif ($item[2] -eq 'Exact')
                                    {
                                        if ($item[1] -is [System.Boolean])
                                        {
                                            "`$_.$($item[0]) -ne `$$($item[1].ToString().ToLower())"
                                        }
                                        else
                                        {
                                            "`$_.$($item[0]) -ne '$($item[1] -replace "'","''")'"
                                        }
                                    }
                                }
                            }
                        )

                        $filterScript = $filterArray -join ' -and '

                        if ($filterScript)
                        {
                            "-FilterScript { $filterScript }"
                        }
                    }
                }
                'AddParameters' = @{
                    'ApplicationType' = '-ApplicationType MSI'
                }
            }
            'Get-FileVersion' = @{
                'NewFunction' = 'Get-ADTFileVersion'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Get-UserProfiles' = @{
                'NewFunction' = 'Get-ADTUserProfiles'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'ExcludeSystemProfiles' = { if ($_ -eq '$false') { '-IncludeSystemProfiles' } }
                    'ExcludeServiceProfiles' = { if ($_ -eq '$false') { '-IncludeServiceProfiles' } }
                }
            }
            'Update-Desktop' = @{
                'NewFunction' = 'Update-ADTDesktop'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Refresh-Desktop' = @{
                'NewFunction' = 'Update-ADTDesktop'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Update-SessionEnvironmentVariables' = @{
                'NewFunction' = 'Update-ADTEnvironmentPsProvider'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Refresh-SessionEnvironmentVariables' = @{
                'NewFunction' = 'Update-ADTEnvironmentPsProvider'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Copy-File' = @{
                'NewFunction' = 'Copy-ADTFile'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'ContinueFileCopyOnError' = { if ($_ -eq '$true') { '-ContinueFileCopyOnError' } else { $null } }
                    'UseRobocopy' = { if ($_ -eq '$true' -or $boundParameters.ContainsKey('RobocopyParams') -or $boundParameters.ContainsKey('RobocopyAdditionalParams')) { '-FileCopyMode Robocopy' } else { '-FileCopyMode Native' } }
                }
            }
            'Remove-File' = @{
                'NewFunction' = 'Remove-ADTFile'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Copy-FileToUserProfiles' = @{
                'NewFunction' = 'Copy-ADTFileToUserProfiles'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'ContinueFileCopyOnError' = { if ($_ -eq '$true') { '-ContinueFileCopyOnError' } else { $null } }
                    'UseRobocopy' = { if ($_ -eq '$true' -or $boundParameters.ContainsKey('RobocopyParams') -or $boundParameters.ContainsKey('RobocopyAdditionalParams')) { '-FileCopyMode Robocopy' } else { '-FileCopyMode Native' } }
                    'ExcludeSystemProfiles' = { if ($_ -eq '$false') { '-IncludeSystemProfiles' } }
                    'ExcludeServiceProfiles' = { if ($_ -eq '$false') { '-IncludeServiceProfiles' } }
                }
            }
            'Show-InstallationPrompt' = @{
                'NewFunction' = 'Show-ADTInstallationPrompt'
                'TransformParameters' = @{
                    'Icon' = { if ($_ -ne 'None') { "-Icon $_" } }
                    'ExitOnTimeout' = { if ($_ -eq '$false') { '-NoExitOnTimeout' } }
                    'TopMost' = { if ($_ -eq '$false') { '-NotTopMost' } }
                }
            }
            'Show-InstallationProgress' = @{
                'NewFunction' = 'Show-ADTInstallationProgress'
                'TransformParameters' = @{
                    'TopMost' = { if ($_ -eq '$false') { '-NotTopMost' } }
                    'Quiet' = '-InformationAction SilentlyContinue' # Should inspect switch values here in case of -Switch:$false
                }
            }
            'Show-DialogBox' = @{
                'NewFunction' = 'Show-ADTDialogBox'
                'TransformParameters' = @{
                    'TopMost' = { if ($_ -eq '$false') { '-NotTopMost' } }
                }
            }
            'Show-InstallationWelcome' = @{
                'NewFunction' = 'Show-ADTInstallationWelcome'
                'TransformParameters' = @{
                    'MinimizeWindows' = { if ($_ -eq '$false') { '-NoMinimizeWindows' } }
                    'TopMost' = { if ($_ -eq '$false') { '-NotTopMost' } }
                    'CloseAppsCountdown' = { "-CloseProcessesCountdown $_" }
                    'ForceCloseAppsCountdown' = { "-ForceCloseProcessesCountdown $_" }
                    'AllowDeferCloseApps' = '-AllowDeferCloseProcesses' # Should inspect switch values here in case of -Switch:$false
                    'CloseApps' = {
                        $quoteChar = if ($boundParameters.CloseApps.Value.StringConstantType -eq 'DoubleQuoted') { '"' } else { "'" }
                        $closeProcesses = $boundParameters.CloseApps.Value.Value.Split(',').ForEach({
                                $name, $description = $_.Split('=')
                                if ($description)
                                {
                                    "@{ Name = $quoteChar$($name)$quoteChar; Description = $quoteChar$($description)$quoteChar }"
                                }
                                else
                                {
                                    "$quoteChar$($name)$quoteChar"
                                }
                            }) -join ', '
                        "-CloseProcesses $closeProcesses"
                    }
                }
            }
            'Get-WindowTitle' = @{
                'NewFunction' = 'Get-ADTWindowTitle'
                'TransformParameters' = @{
                    'DisableFunctionLogging' = '-InformationAction SilentlyContinue' # Should inspect switch values here in case of -Switch:$false
                }
            }
            'Show-InstallationRestartPrompt' = @{
                'NewFunction' = 'Show-ADTInstallationRestartPrompt'
                'TransformParameters' = @{
                    'NoSilentRestart' = { if ($_ -eq '$false') { '-SilentRestart' } }
                    'TopMost' = { if ($_ -eq '$false') { '-NotTopMost' } }
                }
            }
            'Show-BalloonTip' = @{
                'NewFunction' = 'Show-ADTBalloonTip'
                'RemoveParameters' = @(
                    'NoWait'
                )
            }
            'Copy-ContentToCache' = @{
                'NewFunction' = 'Copy-ADTContentToCache'
            }
            'Remove-ContentFromCache' = @{
                'NewFunction' = 'Remove-ADTContentFromCache'
            }
            'Test-NetworkConnection' = @{
                'NewFunction' = 'Test-ADTNetworkConnection'
            }
            'Get-LoggedOnUser' = @{
                'NewFunction' = 'Get-ADTLoggedOnUser'
            }
            'Get-IniValue' = @{
                'NewFunction' = 'Get-ADTIniValue'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Set-IniValue' = @{
                'NewFunction' = 'Set-ADTIniValue'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'New-Folder' = @{
                'NewFunction' = 'New-ADTFolder'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Test-PowerPoint' = @{
                'NewFunction' = 'Test-ADTPowerPoint'
            }
            'Update-GroupPolicy' = @{
                'NewFunction' = 'Update-ADTGroupPolicy'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Get-UniversalDate' = @{
                'NewFunction' = 'Get-ADTUniversalDate'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Test-ServiceExists' = @{
                'NewFunction' = 'Test-ADTServiceExists'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'ComputerName'
                )
            }
            'Disable-TerminalServerInstallMode' = @{
                'NewFunction' = 'Disable-ADTTerminalServerInstallMode'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Enable-TerminalServerInstallMode' = @{
                'NewFunction' = 'Enable-ADTTerminalServerInstallMode'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Configure-EdgeExtension' = @{
                'NewFunction' = { if ($boundParameters.ContainsKey('Add')) { 'Add-ADTEdgeExtension' } else { 'Remove-ADTEdgeExtension' } }  # Should inspect switch values here in case of -Switch:$false
                'RemoveParameters' = @(
                    'Add'
                    'Remove'
                )
            }
            'Resolve-Error' = @{
                'NewFunction' = 'Resolve-ADTErrorRecord'
                'AddParameters' = @{
                    'ExcludeErrorRecord' = {
                        if (!$boundParameters.ContainsKey('GetErrorRecord') -or $boundParameters.GetErrorRecord.ConstantValue -eq $false -or $boundParameters.GetErrorRecord.Value.Extent.Text -eq '$false') { '-ExcludeErrorRecord' }
                    }
                    'ExcludeErrorInvocation' = {
                        if (!$boundParameters.ContainsKey('GetErrorInvocation') -or $boundParameters.GetErrorInvocation.ConstantValue -eq $false -or $boundParameters.GetErrorInvocation.Value.Extent.Text -eq '$false') { '-ExcludeErrorInvocation' }
                    }
                    'ExcludeErrorException' = {
                        if (!$boundParameters.ContainsKey('GetErrorException') -or $boundParameters.GetErrorException.ConstantValue -eq $false -or $boundParameters.GetErrorException.Value.Extent.Text -eq '$false') { '-ExcludeErrorException' }
                    }
                    'ExcludeErrorInnerException' = {
                        if (!$boundParameters.ContainsKey('GetErrorInnerException') -or $boundParameters.GetErrorInnerException.ConstantValue -eq $false -or $boundParameters.GetErrorInnerException.Value.Extent.Text -eq '$false') { '-ExcludeErrorInnerException' }
                    }
                }
            }
            'Get-ServiceStartMode' = @{
                'NewFunction' = 'Get-ADTServiceStartMode'
                'TransformParameters' = @{
                    'Name' = { "-Service $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'ComputerName'
                )
            }
            'Set-ServiceStartMode' = @{
                'NewFunction' = 'Set-ADTServiceStartMode'
                'TransformParameters' = @{
                    'Name' = { "-Service $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'ComputerName'
                )
            }
            'Execute-Process' = @{
                'NewFunction' = 'Start-ADTProcess'
                'TransformParameters' = @{
                    'Path' = { "-FilePath $_" }
                    'Arguments' = { "-ArgumentList $_" }
                    'Parameters' = { "-ArgumentList $_" }
                    'SecureParameters' = '-SecureArgumentList' # Should inspect switch values here in case of -Switch:$false
                    'IgnoreExitCodes' = { "-IgnoreExitCodes $($_.Trim('"').Trim("'") -split ',' -join ',')" }
                    'ExitOnProcessFailure' = {
                        $ContinueOnError = if ($null -eq $boundParameters.ContinueOnError.Value.Extent) { $false } else { $boundParameters.ContinueOnError.Value.SafeGetValue() }
                        $ExitOnProcessFailure = if ($null -eq $boundParameters.ExitOnProcessFailure.Value.Extent) { $true } else { $boundParameters.ExitOnProcessFailure.Value.SafeGetValue() }
                        @('-ErrorAction Stop', '-ErrorAction SilentlyContinue')[$ContinueOnError -or !$ExitOnProcessFailure]
                    }
                    'ContinueOnError' = {
                        $ContinueOnError = if ($null -eq $boundParameters.ContinueOnError.Value.Extent) { $false } else { $boundParameters.ContinueOnError.Value.SafeGetValue() }
                        $ExitOnProcessFailure = if ($null -eq $boundParameters.ExitOnProcessFailure.Value.Extent) { $true } else { $boundParameters.ExitOnProcessFailure.Value.SafeGetValue() }
                        @('-ErrorAction Stop', '-ErrorAction SilentlyContinue')[$ContinueOnError -or !$ExitOnProcessFailure]
                    }
                }
            }
            'Execute-MSI' = @{
                'NewFunction' = 'Start-ADTMsiProcess'
                'TransformParameters' = @{
                    'Path' = { "-FilePath $_" }
                    'Arguments' = { "-ArgumentList $_" }
                    'Parameters' = { "-ArgumentList $_" }
                    'AddParameters' = { "-AdditionalArgumentList $_" }
                    'SecureParameters' = '-SecureArgumentList' # Should inspect switch values here in case of -Switch:$false
                    'LogName' = { "-LogFileName $_" }
                    'IgnoreExitCodes' = { "-IgnoreExitCodes $($_.Trim('"').Trim("'") -split ',' -join ',')" }
                    'ExitOnProcessFailure' = {
                        $ContinueOnError = if ($null -eq $boundParameters.ContinueOnError.Value.Extent) { $false } else { $boundParameters.ContinueOnError.Value.SafeGetValue() }
                        $ExitOnProcessFailure = if ($null -eq $boundParameters.ExitOnProcessFailure.Value.Extent) { $true } else { $boundParameters.ExitOnProcessFailure.Value.SafeGetValue() }
                        @('-ErrorAction Stop', '-ErrorAction SilentlyContinue')[$ContinueOnError -or !$ExitOnProcessFailure]
                    }
                    'ContinueOnError' = {
                        $ContinueOnError = if ($null -eq $boundParameters.ContinueOnError.Value.Extent) { $false } else { $boundParameters.ContinueOnError.Value.SafeGetValue() }
                        $ExitOnProcessFailure = if ($null -eq $boundParameters.ExitOnProcessFailure.Value.Extent) { $true } else { $boundParameters.ExitOnProcessFailure.Value.SafeGetValue() }
                        @('-ErrorAction Stop', '-ErrorAction SilentlyContinue')[$ContinueOnError -or !$ExitOnProcessFailure]
                    }
                }
            }
            'Execute-MSP' = @{
                'NewFunction' = 'Start-ADTMspProcess'
                'TransformParameters' = @{
                    'Path' = { "-FilePath $_" }
                }
            }
            'Block-AppExecution' = @{
                'NewFunction' = 'Block-ADTAppExecution'
            }
            'Unblock-AppExecution' = @{
                'NewFunction' = 'Unblock-ADTAppExecution'
            }
            'Test-RegistryValue' = @{
                'NewFunction' = 'Test-ADTRegistryValue'
                'TransformParameters' = @{
                    'Value' = { "-Name $_" }
                }
            }
            'Convert-RegistryPath' = @{
                'NewFunction' = 'Convert-ADTRegistryPath'
                'TransformParameters' = @{
                    'DisableFunctionLogging' = { if ($_ -eq '$false') { '-InformationAction Continue' } }
                }
            }
            'Test-MSUpdates' = @{
                'NewFunction' = 'Test-ADTMSUpdates'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Test-Battery' = @{
                'NewFunction' = 'Test-ADTBattery'
            }
            'Start-ServiceAndDependencies' = @{
                'NewFunction' = 'Start-ADTServiceAndDependencies'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'ComputerName'
                    'SkipServiceExistsTest'
                )
            }
            'Stop-ServiceAndDependencies' = @{
                'NewFunction' = 'Stop-ADTServiceAndDependencies'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'ComputerName'
                    'SkipServiceExistsTest'
                )
            }
            'Set-RegistryKey' = @{
                'NewFunction' = 'Set-ADTRegistryKey'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Remove-RegistryKey' = @{
                'NewFunction' = 'Remove-ADTRegistryKey'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Remove-FileFromUserProfiles' = @{
                'NewFunction' = 'Remove-ADTFileFromUserProfiles'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'ExcludeSystemProfiles' = { if ($_ -eq '$false') { '-IncludeSystemProfiles' } }
                    'ExcludeServiceProfiles' = { if ($_ -eq '$false') { '-IncludeServiceProfiles' } }
                }
            }
            'Get-RegistryKey' = @{
                'NewFunction' = 'Get-ADTRegistryKey'
                'TransformParameters' = @{
                    'Value' = { "-Name $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Install-MSUpdates' = @{
                'NewFunction' = 'Install-ADTMSUpdates'
            }
            'Get-SchedulerTask' = @{
                'NewFunction' = 'Get-ADTSchedulerTask'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Get-PendingReboot' = @{
                'NewFunction' = 'Get-ADTPendingReboot'
            }
            'Invoke-RegisterOrUnregisterDLL' = @{
                'NewFunction' = 'Invoke-ADTRegSvr32'
                'TransformParameters' = @{
                    'DLLAction' = { "-Action $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Register-DLL' = @{
                'NewFunction' = 'Register-ADTDll'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Unregister-DLL' = @{
                'NewFunction' = 'Unregister-ADTDll'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Remove-Folder' = @{
                'NewFunction' = 'Remove-ADTFolder'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Set-ActiveSetup' = @{
                'NewFunction' = 'Set-ADTActiveSetup'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'ExecuteForCurrentUser' = { if ($_ -eq '$false') { '-NoExecuteForCurrentUser' } }
                }
            }
            'Set-ItemPermission' = @{
                'NewFunction' = 'Set-ADTItemPermission'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'File' = { "-Path $_" }
                    'Folder' = { "-Path $_" }
                    'Username' = { "-User $_" }
                    'Users' = { "-User $_" }
                    'SID' = { "-User $_" }
                    'Usernames' = { "-User $_" }
                    'Acl' = { "-Permission $_" }
                    'Grant' = { "-Permission $_" }
                    'Permissions' = { "-Permission $_" }
                    'Deny' = { "-Permission $_" }
                    'AccessControlType' = { "-PermissionType $_" }
                    'Add' = { "-Method $($_ -replace '^(Add|Set|Reset|Remove)(Specific|All)?$', '$1AccessRule$2')" }
                    'ApplyMethod' = { "-Method $($_ -replace '^(Add|Set|Reset|Remove)(Specific|All)?$', '$1AccessRule$2')" }
                    'ApplicationMethod' = { "-Method $($_ -replace '^(Add|Set|Reset|Remove)(Specific|All)?$', '$1AccessRule$2')" }
                    'Method' = { "-Method $($_ -replace '^(Add|Set|Reset|Remove)(Specific|All)?$', '$1AccessRule$2')" }
                }
            }
            'New-MsiTransform' = @{
                'NewFunction' = 'New-ADTMsiTransform'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Invoke-SCCMTask' = @{
                'NewFunction' = 'Invoke-ADTSCCMTask'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Install-SCCMSoftwareUpdates' = @{
                'NewFunction' = 'Install-ADTSCCMSoftwareUpdates'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Send-Keys' = @{
                'NewFunction' = 'Send-ADTKeys'
            }
            'Get-Shortcut' = @{
                'NewFunction' = 'Get-ADTShortcut'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Set-Shortcut' = @{
                'NewFunction' = 'Set-ADTShortcut'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'New-Shortcut' = @{
                'NewFunction' = 'New-ADTShortcut'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Execute-ProcessAsUser' = @{
                'NewFunction' = 'Start-ADTProcessAsUser'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'TempPath'
                    'RunLevel'
                )
            }
            'Close-InstallationProgress' = @{
                'NewFunction' = 'Close-ADTInstallationProgress'
                'RemoveParameters' = @(
                    'WaitingTime'
                )
            }
            'ConvertTo-NTAccountOrSID' = @{
                'NewFunction' = 'ConvertTo-ADTNTAccountOrSID'
            }
            'Get-DeferHistory' = @{
                'NewFunction' = 'Get-ADTDeferHistory'
            }
            'Set-DeferHistory' = @{
                'NewFunction' = 'Set-ADTDeferHistory'
            }
            'Get-MsiTableProperty' = @{
                'NewFunction' = 'Get-ADTMsiTableProperty'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Set-MsiProperty' = @{
                'NewFunction' = 'Set-ADTMsiProperty'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Get-MsiExitCodeMessage' = @{
                'NewFunction' = 'Get-ADTMsiExitCodeMessage'
            }
            'Get-ObjectProperty' = @{
                'NewFunction' = 'Get-ADTObjectProperty'
            }
            'Invoke-ObjectMethod' = @{
                'NewFunction' = 'Invoke-ADTObjectMethod'
            }
            'Get-PEFileArchitecture' = @{
                'NewFunction' = 'Get-ADTPEFileArchitecture'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Test-IsMutexAvailable' = @{
                'NewFunction' = 'Test-ADTMutexAvailability'
            }
            'New-ZipFile' = @{
                'NewFunction' = 'New-ADTZipFile'
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                    'DestinationArchiveDirectoryPath' = {
                        $destinationArchiveDirectoryPath = $boundParameters.DestinationArchiveDirectoryPath.Value.Value
                        $destinationArchiveFileName = $boundParameters.DestinationArchiveFileName.Value.Value
                        $quoteChar = if ($boundParameters.DestinationArchiveDirectoryPath.Value.StringConstantType -eq 'DoubleQuoted' -or $boundParameters.DestinationArchiveFileName.Value.StringConstantType -eq 'DoubleQuoted') { '"' } else { "'" }
                        "-DestinationPath $quoteChar$([System.IO.Path]::Combine($destinationArchiveDirectoryPath, $destinationArchiveFileName))$quoteChar"
                    }
                    'DestinationArchiveFileName' = {
                        $destinationArchiveDirectoryPath = $boundParameters.DestinationArchiveDirectoryPath.Value.Value
                        $destinationArchiveFileName = $boundParameters.DestinationArchiveFileName.Value.Value
                        $quoteChar = if ($boundParameters.DestinationArchiveDirectoryPath.Value.StringConstantType -eq 'DoubleQuoted' -or $boundParameters.DestinationArchiveFileName.Value.StringConstantType -eq 'DoubleQuoted') { '"' } else { "'" }
                        "-DestinationPath $quoteChar$([System.IO.Path]::Combine($destinationArchiveDirectoryPath, $destinationArchiveFileName))$quoteChar"
                    }
                    'SourceDirectoryPath' = { "-LiteralPath $_" }
                    'SourceFilePath' = { "-LiteralPath $_" }
                    'OverWriteArchive' = '-Force' # Should inspect switch values here in case of -Switch:$false
                }
            }
            'Set-PinnedApplication' = @{
                'NewFunction' = '# The function [Set-PinnedApplication] has been removed from PSAppDeployToolkit as its functionality no longer works with Windows 10 1809 or higher targets.'
            }
        }

        $spBinder = [System.Management.Automation.Language.StaticParameterBinder]
    }

    Process
    {
        try
        {
            # Get legacy variables
            [ScriptBlock]$variablePredicate = {
                param ([System.Management.Automation.Language.Ast]$Ast)
                $Ast -is [System.Management.Automation.Language.VariableExpressionAst] -and $Ast.Parent -isnot [System.Management.Automation.Language.ParameterAst] -and $Ast.VariablePath.UserPath -in $variableMappings.Keys
            }
            [System.Management.Automation.Language.Ast[]]$variableAsts = $ScriptBlockAst.FindAll($variablePredicate, $true)

            # Get legacy functions
            [ScriptBlock]$commandPredicate = {
                param ([System.Management.Automation.Language.Ast]$Ast)
                $Ast -is [System.Management.Automation.Language.CommandAst] -and $Ast.GetCommandName() -in $functionMappings.Keys
            }
            [System.Management.Automation.Language.Ast[]]$commandAsts = $ScriptBlockAst.FindAll($commandPredicate, $true)

            # Process all hashtable definitions that splat to legacy functions first
            foreach ($commandAst in $commandAsts)
            {
                $functionName = $commandAst.GetCommandName()
                $boundParameters = ($spBinder::BindCommand($commandAst, $true)).BoundParameters

                foreach ($boundParameter in $boundParameters.GetEnumerator())
                {
                    if ($boundParameter.Value.Value.Splatted)
                    {
                        $splatVariableName = $boundParameter.Value.Value.VariablePath.UserPath

                        # Find the last assignment of the splat variable before the current command
                        [ScriptBlock]$splatPredicate = {
                            param ([System.Management.Automation.Language.Ast]$Ast)
                            $Ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and $Ast.Left.Extent.Text -match "\`$$splatVariableName$" -and ($Ast.Extent.StartLineNumber -lt $commandAst.Extent.StartLineNumber -or ($Ast.Extent.StartLineNumber -eq $commandAst.Extent.StartLineNumber -and $Ast.Extent.StartColumnNumber -lt $commandAst.Extent.StartColumnNumber))
                        }
                        [System.Management.Automation.Language.Ast]$splatAst = $ScriptBlockAst.FindAll($splatPredicate, $true) | Select-Object -Last 1

                        if ($splatAst)
                        {
                            $splatModified = $false
                            $outputMessage = New-Object System.Text.StringBuilder
                            $outputMessage.AppendLine("Modify splat `$$splatVariableName`:") | Out-Null

                            # Construct a hashtable in text form
                            $replacementHashText = New-Object System.Text.StringBuilder
                            if ($splatAst.Extent.StartLineNumber -eq $splatAst.Extent.EndLineNumber)
                            {
                                $splatHashLineSeparator = ' '
                                $splatHashItemSeparator = '; '
                                $splatHashIndent = 0
                            }
                            else
                            {
                                $splatHashLineSeparator = "`n"
                                $splatHashItemSeparator = "`n"
                                $splatHashIndent = $splatAst.Extent.StartColumnNumber + 3
                            }
                            $replacementHashText.Append("$($splatAst.Left.Extent.Text) = @{$splatHashLineSeparator") | Out-Null

                            $replacementHashItems = foreach ($keyValuePair in $splatAst.Right.Expression.KeyValuePairs)
                            {
                                if ($keyValuePair.Item1.Value -in $functionMappings[$functionName].RemoveParameters)
                                {
                                    $splatModified = $true
                                    continue
                                }
                                if ($keyValuePair.Item1.Value -in $functionMappings[$functionName].TransformParameters.Keys)
                                {
                                    $splatModified = $true

                                    if ($functionMappings[$functionName].TransformParameters[$keyValuePair.Item1.Value] -is [ScriptBlock])
                                    {
                                        # If parameter is remapped to a script block, invoke it to get the new parameter
                                        $splatNewParam = ForEach-Object -InputObject $keyValuePair.Item2 -Process $functionMappings[$functionName].TransformParameters[$keyValuePair.Item1.Value]
                                    }
                                    else
                                    {
                                        # Otherwise, use the new parameter name as-is
                                        $splatNewParam = $functionMappings[$functionName].TransformParameters[$keyValuePair.Item1.Value]
                                    }

                                    # Split splatNewParam into parameter name and value
                                    if ($splatNewParam -match "-([a-zA-Z0-9_-]+)\s*(.*)?")
                                    {
                                        $paramName = $matches[1]
                                        $paramValue = $matches[2]
                                        if ([string]::IsNullOrWhiteSpace($paramValue))
                                        {
                                            # Assume if no value is provided it's a switch parameter, which in a hashtable for splatting, needs to be set to $true
                                            $paramValue = '$true'
                                        }
                                        "$(' ' * $splatHashIndent)$paramName = $paramValue"

                                        $outputMessage.AppendLine("$($keyValuePair.Item1.Value) = $($keyValuePair.Item2.Extent.Text)  →  $paramName = $paramValue") | Out-Null
                                    }
                                }
                                else
                                {
                                    # Write the key-value pair as-is
                                    "$(' ' * $splatHashIndent)$($keyValuePair.Item1.Value) = $($keyValuePair.Item2.Extent.Text)"
                                }
                            }

                            if ($splatModified)
                            {
                                $replacementHashText.Append($replacementHashItems -join $splatHashItemSeparator) | Out-Null
                                $replacementHashText.Append("$splatHashLineSeparator$(' ' * ([math]::Max(0, $splatHashIndent - 4)))}") | Out-Null

                                # Create a CorrectionExtent object for the suggested correction
                                $objParams = @{
                                    TypeName = 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent'
                                    ArgumentList = @(
                                        $splatAst.Extent.StartLineNumber
                                        $splatAst.Extent.EndLineNumber
                                        $splatAst.Extent.StartColumnNumber
                                        $splatAst.Extent.EndColumnNumber
                                        $replacementHashText.ToString()
                                        $MyInvocation.MyCommand.Definition
                                        "More information: https://psappdeploytoolkit.com/docs/reference/functions"
                                    )
                                }
                                $correctionExtent = New-Object @objParams
                                $suggestedCorrections = New-Object System.Collections.ObjectModel.Collection[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent]
                                $suggestedCorrections.Add($correctionExtent) | Out-Null

                                # Output the diagnostic record in the format expected by the ScriptAnalyzer
                                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                                    Message = $outputMessage.ToString().Trim()
                                    Extent = $splatAst.Extent
                                    RuleName = 'Measure-ADTCompatibility'
                                    Severity = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning
                                    RuleSuppressionID = 'ADTCompatibilitySuppression'
                                    SuggestedCorrections = $suggestedCorrections
                                }
                            }
                        }
                    }
                }
            }

            # Process all legacy variables second
            foreach ($variableAst in $variableAsts)
            {
                $variableName = $variableAst.VariablePath.UserPath
                $newVariable = $variableMappings[$variableName]

                if ([string]::IsNullOrWhiteSpace($newVariable))
                {
                    $outputMessage = "The variable [`$$variableName] is deprecated and no longer available."
                    $suggestedCorrections = $null
                }
                else
                {
                    if ($newVariable -match 'ADTSession')
                    {
                        $outputMessage = "The variable [`$$variableName] is now a session variable and no longer directly available. Use [$newVariable] instead."
                    }
                    elseif ($newVariable -match 'ADTConfig')
                    {
                        $outputMessage = "The variable [`$$variableName] is now a config variable and no longer directly available. Use [$newVariable] instead."
                    }
                    elseif ($newVariable -match 'ADTString')
                    {
                        $outputMessage = "The variable [`$$variableName] is now a localization string variable and no longer directly available. Use [$newVariable] instead."
                    }
                    else
                    {
                        $outputMessage = "The variable [`$$variableName] is deprecated. Use [$newVariable] instead."
                    }

                    if ($newVariable -like '*.*' -and $variableAst.Parent.StringConstantType -in [System.Management.Automation.Language.StringConstantType]'DoubleQuoted', [System.Management.Automation.Language.StringConstantType]'DoubleQuotedHereString')
                    {
                        # Wrap variable in $() if it is contains a . and is used in a double-quoted string
                        $newVariable = "`$($newVariable)"
                    }

                    # Create a CorrectionExtent object for the suggested correction
                    $objParams = @{
                        TypeName = 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent'
                        ArgumentList = @(
                            $variableAst.Extent.StartLineNumber
                            $variableAst.Extent.EndLineNumber
                            $variableAst.Extent.StartColumnNumber
                            $variableAst.Extent.EndColumnNumber
                            $newVariable
                            $MyInvocation.MyCommand.Definition
                            'More information: https://psappdeploytoolkit.com/docs/reference/variables'
                        )
                    }
                    $correctionExtent = New-Object @objParams
                    $suggestedCorrections = New-Object System.Collections.ObjectModel.Collection[$($objParams.TypeName)]
                    $suggestedCorrections.Add($correctionExtent) | Out-Null
                }

                # Output the diagnostic record in the format expected by the ScriptAnalyzer
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message = $outputMessage
                    Extent = $variableAst.Extent
                    RuleName = 'Measure-ADTCompatibility'
                    Severity = 'Warning'
                    RuleSuppressionID = 'ADTCompatibilitySuppression'
                    SuggestedCorrections = $suggestedCorrections
                }
            }

            # Redefine legacy functions last
            foreach ($commandAst in $commandAsts)
            {
                $functionName = $commandAst.GetCommandName()

                # Use a StringBuilder for the output message, but a collection for newParams, since we want to search it as we go to avoid duplicate insertions, which are possible when multiple v3 parameters are combined into one
                $outputMessage = New-Object System.Text.StringBuilder
                $newParams = New-Object System.Collections.Generic.List[System.String]

                if ($functionMappings[$functionName].NewFunction -match '^#')
                {
                    # If function is remapped to a comment, use the comment as the message and skip parameter processing
                    $newFunction = $functionMappings[$functionName].NewFunction
                    $outputMessage.AppendLine($newFunction.TrimStart('#').Trim()) | Out-Null
                }
                else
                {
                    # Define these parameters first since scriptblocks may reference them
                    $boundParameters = ($spBinder::BindCommand($commandAst, $true)).BoundParameters

                    if ($functionMappings[$functionName].NewFunction -is [ScriptBlock])
                    {
                        # If function is remapped to a script block, invoke it to get the new function name
                        $newFunction = Invoke-Command -ScriptBlock $functionMappings[$functionName].NewFunction
                    }
                    else
                    {
                        # Otherwise, use the new function name as-is
                        $newFunction = $functionMappings[$functionName].NewFunction
                    }

                    $outputMessage.AppendLine("The function [$functionName] is deprecated, use [$newFunction] instead.") | Out-Null

                    foreach ($boundParameter in $boundParameters.GetEnumerator())
                    {
                        if ($boundParameter.Key -in $functionMappings[$functionName].RemoveParameters)
                        {
                            $outputMessage.AppendLine("-$($boundParameter.Key) is deprecated.") | Out-Null
                            continue
                        }
                        if ($boundParameter.Key -in $functionMappings[$functionName].TransformParameters.Keys)
                        {
                            if ($functionMappings[$functionName].TransformParameters[$boundParameter.Key] -is [ScriptBlock])
                            {
                                # If parameter is remapped to a script block, invoke it to get the new parameter
                                $newParam = ForEach-Object -InputObject $boundParameter.Value.Value.Extent.Text -Process $functionMappings[$functionName].TransformParameters[$boundParameter.Key]
                            }
                            else
                            {
                                # Otherwise, use the new parameter name as-is
                                $newParam = $functionMappings[$functionName].TransformParameters[$boundParameter.Key]
                            }

                            if ([string]::IsNullOrWhiteSpace($newParam))
                            {
                                # If newParam is empty, assume parameter should be removed (RemoveParameters definition is preferred, but it is not suitable for conditional removals)
                                $outputMessage.AppendLine("Removed parameter: -$($boundParameter.Key)") | Out-Null
                                continue
                            }
                            if ($newParams.Contains($newParam))
                            {
                                # If the new param value is already present in the new command, skip it. This can happen when 2 parameters are combined into one in the new syntax (e.g. Remove-MSIApplications -FilterApplication -ExcludeFromUninstall)
                                continue
                            }

                            if ($boundParameter.Value.ConstantValue -and $boundParameter.Value.Value.ParameterName -eq $boundParameter.Key)
                            {
                                # This is a simple switch
                                $outputMessage.AppendLine("-$($boundParameter.Key)  →  $newParam") | Out-Null
                            }
                            elseif ($boundParameter.Key -eq $boundParameter.Value.Value.Parent.ParameterName)
                            {
                                # This is a switch bound with a value, e.g. -Switch:$true
                                $outputMessage.AppendLine("-$($boundParameter.Key)  →  $newParam") | Out-Null
                            }
                            else
                            {
                                # This is a regular parameter, e.g. -Path 'xxx'
                                $outputMessage.AppendLine("-$($boundParameter.Key) $($boundParameter.Value.Value.Extent.Text)  →  $newParam") | Out-Null
                            }
                        }
                        else
                        {
                            # If not removed or transformed, pass through original parameter as-is, making some assumptions about the parsed input to do so
                            if ($boundParameter.Value.ConstantValue -and $boundParameter.Value.Value.ParameterName -eq $boundParameter.Key)
                            {
                                # This is a simple switch
                                $newParam = "-$($boundParameter.Key)"
                            }
                            elseif ($boundParameter.Key -eq $boundParameter.Value.Value.Parent.ParameterName)
                            {
                                # This is a switch bound with a value, e.g. -Switch:$true
                                $newParam = $boundParameters.Value.Value.Parent.Extent.Text
                            }
                            elseif ($boundParameter.Value.Value.Splatted)
                            {
                                # This is a splatted parameter, e.g. @params, retain the original value
                                $NewParam = $boundParameter.Value.Value.Extent.Text
                            }
                            else
                            {
                                # This is a regular parameter, e.g. -Path 'xxx'
                                $newParam = "-$($boundParameter.Key) $($boundParameter.Value.Value.Extent.Text)"
                            }
                        }

                        if (![string]::IsNullOrWhiteSpace($newParam))
                        {
                            $newParams.Add($newParam) | Out-Null
                        }
                    }

                    foreach ($addParameter in $functionMappings[$functionName].AddParameters.Keys)
                    {
                        if ($functionMappings[$functionName].AddParameters[$addParameter] -is [ScriptBlock])
                        {
                            # If parameter is remapped to a script block, invoke it to get the new parameter
                            $newParam = ForEach-Object -InputObject $addParameter -Process $functionMappings[$functionName].AddParameters[$addParameter]
                        }
                        else
                        {
                            # Otherwise, use the new parameter name as-is
                            $newParam = $functionMappings[$functionName].AddParameters[$addParameter]
                        }

                        if (![string]::IsNullOrWhiteSpace($newParam))
                        {
                            $newParams.Add($newParam) | Out-Null
                            $outputMessage.AppendLine("Add Parameter: $newParam") | Out-Null
                        }
                    }
                }

                # Construct the new command
                $newCommand = $newFunction + ' ' + ($newParams -join ' ')

                # Create a CorrectionExtent object for the suggested correction
                $objParams = @{
                    TypeName = 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent'
                    ArgumentList = @(
                        $commandAst.Extent.StartLineNumber
                        $commandAst.Extent.EndLineNumber
                        $commandAst.Extent.StartColumnNumber
                        $commandAst.Extent.EndColumnNumber
                        $newCommand
                        $MyInvocation.MyCommand.Definition
                        "More information: https://psappdeploytoolkit.com/docs/reference/functions"
                    )
                }
                $correctionExtent = New-Object @objParams
                $suggestedCorrections = New-Object System.Collections.ObjectModel.Collection[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent]
                $suggestedCorrections.Add($correctionExtent) | Out-Null

                # Output the diagnostic record in the format expected by the ScriptAnalyzer
                [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message = $outputMessage.ToString().Trim()
                    Extent = $commandAst.Extent
                    RuleName = 'Measure-ADTCompatibility'
                    Severity = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning
                    RuleSuppressionID = 'ADTCompatibilitySuppression'
                    SuggestedCorrections = $suggestedCorrections
                }
            }


        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

Export-ModuleMember Measure-ADTCompatibility
