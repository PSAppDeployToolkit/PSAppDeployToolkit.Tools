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
        if ($ScriptBlockAst.Parent) { return } # Only process the root ScriptBlockAst

        #region PSAppDeployToolkit v3.10.2 Function Definitions
        function Write-FunctionHeaderOrFooter
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$CmdletName,
                [Parameter(Mandatory = $true, ParameterSetName = 'Header')]
                [AllowEmptyCollection()]
                [Hashtable]$CmdletBoundParameters,
                [Parameter(Mandatory = $true, ParameterSetName = 'Header')]
                [Switch]$Header,
                [Parameter(Mandatory = $true, ParameterSetName = 'Footer')]
                [Switch]$Footer
            )
        }

        function Execute-MSP
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [Alias('FilePath')]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [String]$AddParameters
            )
        }

        function Write-Log
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [AllowEmptyCollection()]
                [Alias('Text')]
                [String[]]$Message,
                [Parameter(Mandatory = $false, Position = 1)]
                [Int16]$Severity,
                [Parameter(Mandatory = $false, Position = 2)]
                [String]$Source,
                [Parameter(Mandatory = $false, Position = 3)]
                [String]$ScriptSection,
                [Parameter(Mandatory = $false, Position = 4)]
                [String]$LogType,
                [Parameter(Mandatory = $false, Position = 5)]
                [String]$LogFileDirectory,
                [Parameter(Mandatory = $false, Position = 6)]
                [String]$LogFileName,
                [Parameter(Mandatory = $false, Position = 7)]
                [Boolean]$AppendToLogFile,
                [Parameter(Mandatory = $false, Position = 8)]
                [Int]$MaxLogHistory,
                [Parameter(Mandatory = $false, Position = 9)]
                [Decimal]$MaxLogFileSizeMB,
                [Parameter(Mandatory = $false, Position = 10)]
                [Boolean]$ContinueOnError,
                [Parameter(Mandatory = $false, Position = 11)]
                [Boolean]$WriteHost,
                [Parameter(Mandatory = $false, Position = 12)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false, Position = 13)]
                [Switch]$DebugMessage,
                [Parameter(Mandatory = $false, Position = 14)]
                [Boolean]$LogDebugMessage
            )
            process
            {
            }
        }

        function Remove-InvalidFileNameChars
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [AllowEmptyString()]
                [String]$Name
            )
            process
            {
            }
        }

        function New-ZipFile
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding(DefaultParameterSetName = 'CreateFromDirectory')]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String]$DestinationArchiveDirectoryPath,
                [Parameter(Mandatory = $true, Position = 1)]
                [String]$DestinationArchiveFileName,
                [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'CreateFromDirectory')]
                [String[]]$SourceDirectoryPath,
                [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'CreateFromFile')]
                [String[]]$SourceFilePath,
                [Parameter(Mandatory = $false, Position = 3)]
                [Switch]$RemoveSourceAfterArchiving,
                [Parameter(Mandatory = $false, Position = 4)]
                [Switch]$OverWriteArchive,
                [Parameter(Mandatory = $false, Position = 5)]
                [Boolean]$ContinueOnError
            )
        }

        function Exit-Script
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Int32]$ExitCode
            )
        }

        function Resolve-Error
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [AllowEmptyCollection()]
                [Array]$ErrorRecord,
                [Parameter(Mandatory = $false, Position = 1)]
                [String[]]$Property,
                [Parameter(Mandatory = $false, Position = 2)]
                [Switch]$GetErrorRecord,
                [Parameter(Mandatory = $false, Position = 3)]
                [Switch]$GetErrorInvocation,
                [Parameter(Mandatory = $false, Position = 4)]
                [Switch]$GetErrorException,
                [Parameter(Mandatory = $false, Position = 5)]
                [Switch]$GetErrorInnerException
            )
            process
            {
            }
        }

        function Show-InstallationPrompt
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$Title,
                [Parameter(Mandatory = $false)]
                [String]$Message,
                [Parameter(Mandatory = $false)]
                [String]$MessageAlignment,
                [Parameter(Mandatory = $false)]
                [String]$ButtonRightText,
                [Parameter(Mandatory = $false)]
                [String]$ButtonLeftText,
                [Parameter(Mandatory = $false)]
                [String]$ButtonMiddleText,
                [Parameter(Mandatory = $false)]
                [String]$Icon,
                [Parameter(Mandatory = $false)]
                [Switch]$NoWait,
                [Parameter(Mandatory = $false)]
                [Switch]$PersistPrompt,
                [Parameter(Mandatory = $false)]
                [Boolean]$MinimizeWindows,
                [Parameter(Mandatory = $false)]
                [Int32]$Timeout,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExitOnTimeout,
                [Parameter(Mandatory = $false)]
                [Boolean]$TopMost
            )
        }

        function Show-DialogBox
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String]$Text,
                [Parameter(Mandatory = $false)]
                [String]$Title,
                [Parameter(Mandatory = $false)]
                [String]$Buttons,
                [Parameter(Mandatory = $false)]
                [String]$DefaultButton,
                [Parameter(Mandatory = $false)]
                [String]$Icon,
                [Parameter(Mandatory = $false)]
                [String]$Timeout,
                [Parameter(Mandatory = $false)]
                [Boolean]$TopMost
            )
        }

        function Get-HardwarePlatform
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-FreeDiskSpace
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$Drive,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-InstalledApplication
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String[]]$Name,
                [Parameter(Mandatory = $false)]
                [Switch]$Exact,
                [Parameter(Mandatory = $false)]
                [Switch]$WildCard,
                [Parameter(Mandatory = $false)]
                [Switch]$RegEx,
                [Parameter(Mandatory = $false)]
                [String]$ProductCode,
                [Parameter(Mandatory = $false)]
                [Switch]$IncludeUpdatesAndHotfixes
            )
        }

        function Execute-MSI
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$Action,
                [Parameter(Mandatory = $true)]
                [Alias('FilePath')]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [String]$Transform,
                [Parameter(Mandatory = $false)]
                [Alias('Arguments')]
                [String]$Parameters,
                [Parameter(Mandatory = $false)]
                [String]$AddParameters,
                [Parameter(Mandatory = $false)]
                [Switch]$SecureParameters,
                [Parameter(Mandatory = $false)]
                [String]$Patch,
                [Parameter(Mandatory = $false)]
                [String]$LoggingOptions,
                [Parameter(Mandatory = $false)]
                [Alias('LogName')]
                [String]$private:LogName,
                [Parameter(Mandatory = $false)]
                [String]$WorkingDirectory,
                [Parameter(Mandatory = $false)]
                [Switch]$SkipMSIAlreadyInstalledCheck,
                [Parameter(Mandatory = $false)]
                [Switch]$IncludeUpdatesAndHotfixes,
                [Parameter(Mandatory = $false)]
                [Switch]$NoWait,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [String]$IgnoreExitCodes,
                [Parameter(Mandatory = $false)]
                [Diagnostics.ProcessPriorityClass]$PriorityClass,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExitOnProcessFailure,
                [Parameter(Mandatory = $false)]
                [Boolean]$RepairFromSource,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Remove-MSIApplications
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [Switch]$Exact,
                [Parameter(Mandatory = $false)]
                [Switch]$WildCard,
                [Parameter(Mandatory = $false)]
                [Alias('Arguments')]
                [String]$Parameters,
                [Parameter(Mandatory = $false)]
                [String]$AddParameters,
                [Parameter(Mandatory = $false)]
                [Array]$FilterApplication,
                [Parameter(Mandatory = $false)]
                [Array]$ExcludeFromUninstall,
                [Parameter(Mandatory = $false)]
                [Switch]$IncludeUpdatesAndHotfixes,
                [Parameter(Mandatory = $false)]
                [String]$LoggingOptions,
                [Parameter(Mandatory = $false)]
                [Alias('LogName')]
                [String]$private:LogName,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Execute-Process
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [Alias('FilePath')]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [Alias('Arguments')]
                [String[]]$Parameters,
                [Parameter(Mandatory = $false)]
                [Switch]$SecureParameters,
                [Parameter(Mandatory = $false)]
                [Diagnostics.ProcessWindowStyle]$WindowStyle,
                [Parameter(Mandatory = $false)]
                [Switch]$CreateNoWindow,
                [Parameter(Mandatory = $false)]
                [String]$WorkingDirectory,
                [Parameter(Mandatory = $false)]
                [Switch]$NoWait,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [Switch]$WaitForMsiExec,
                [Parameter(Mandatory = $false)]
                [Int32]$MsiExecWaitTime,
                [Parameter(Mandatory = $false)]
                [String]$IgnoreExitCodes,
                [Parameter(Mandatory = $false)]
                [Diagnostics.ProcessPriorityClass]$PriorityClass,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExitOnProcessFailure,
                [Parameter(Mandatory = $false)]
                [Boolean]$UseShellExecute,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-MsiExitCodeMessage
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [Int32]$MsiExitCode
            )
        }

        function Test-IsMutexAvailable
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$MutexName,
                [Parameter(Mandatory = $false)]
                [Int32]$MutexWaitTimeInMilliseconds
            )
        }

        function New-Folder
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Remove-Folder
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [Switch]$DisableRecursion,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Copy-File
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String[]]$Path,
                [Parameter(Mandatory = $true, Position = 1)]
                [String]$Destination,
                [Parameter(Mandatory = $false)]
                [Switch]$Recurse,
                [Parameter(Mandatory = $false)]
                [Switch]$Flatten,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueFileCopyOnError,
                [Parameter(Mandatory = $false)]
                [Boolean]$UseRobocopy,
                [Parameter(Mandatory = $false)]
                [String]$RobocopyParams,
                [String]$RobocopyAdditionalParams
            )
        }

        function Remove-File
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, ParameterSetName = 'Path')]
                [String[]]$Path,
                [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPath')]
                [String[]]$LiteralPath,
                [Parameter(Mandatory = $false)]
                [Switch]$Recurse,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Copy-FileToUserProfiles
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
                [String[]]$Path,
                [Parameter(Mandatory = $false, Position = 2)]
                [String]$Destination,
                [Parameter(Mandatory = $false)]
                [Switch]$Recurse,
                [Parameter(Mandatory = $false)]
                [Switch]$Flatten,
                [Parameter(Mandatory = $false)]
                [Boolean]$UseRobocopy,
                [Parameter(Mandatory = $false)]
                [String]$RobocopyAdditionalParams,
                [Parameter(Mandatory = $false)]
                [String[]]$ExcludeNTAccount,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExcludeSystemProfiles,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExcludeServiceProfiles,
                [Parameter(Mandatory = $false)]
                [Switch]$ExcludeDefaultUser,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueFileCopyOnError
            )
            process
            {
            }
        }

        function Remove-FileFromUserProfiles
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Path')]
                [String[]]$Path,
                [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'LiteralPath')]
                [String[]]$LiteralPath,
                [Parameter(Mandatory = $false)]
                [Switch]$Recurse,
                [Parameter(Mandatory = $false)]
                [String[]]$ExcludeNTAccount,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExcludeSystemProfiles,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExcludeServiceProfiles,
                [Parameter(Mandatory = $false)]
                [Switch]$ExcludeDefaultUser,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Convert-RegistryPath
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Key,
                [Parameter(Mandatory = $false)]
                [Switch]$Wow6432Node,
                [Parameter(Mandatory = $false)]
                [String]$SID,
                [Parameter(Mandatory = $false)]
                [Boolean]$DisableFunctionLogging
            )
        }

        function Test-RegistryValue
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [Parameter(Mandatory = $true, Position = 1)]
                [Parameter(Mandatory = $false, Position = 2)]
                [String]$SID,
                [Parameter(Mandatory = $false)]
                [Switch]$Wow6432Node
            )
            process
            {
            }
        }

        function Get-RegistryKey
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Key,
                [Parameter(Mandatory = $false)]
                [String]$Value,
                [Parameter(Mandatory = $false)]
                [Switch]$Wow6432Node,
                [Parameter(Mandatory = $false)]
                [String]$SID,
                [Parameter(Mandatory = $false)]
                [Switch]$ReturnEmptyKeyIfExists,
                [Parameter(Mandatory = $false)]
                [Switch]$DoNotExpandEnvironmentNames,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Set-RegistryKey
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Key,
                [Parameter(Mandatory = $false)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                $Value,
                [Parameter(Mandatory = $false)]
                [Microsoft.Win32.RegistryValueKind]$Type,
                [Parameter(Mandatory = $false)]
                [Switch]$Wow6432Node,
                [Parameter(Mandatory = $false)]
                [String]$SID,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Remove-RegistryKey
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Key,
                [Parameter(Mandatory = $false)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [Switch]$Recurse,
                [Parameter(Mandatory = $false)]
                [String]$SID,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Invoke-HKCURegistrySettingsForAllUsers
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [ScriptBlock]$RegistrySettings,
                [Parameter(Mandatory = $false)]
                [PSObject[]]$UserProfiles
            )
        }

        function ConvertTo-NTAccountOrSID
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, ParameterSetName = 'NTAccountToSID', ValueFromPipelineByPropertyName = $true)]
                [String]$AccountName,
                [Parameter(Mandatory = $true, ParameterSetName = 'SIDToNTAccount', ValueFromPipelineByPropertyName = $true)]
                [String]$SID,
                [Parameter(Mandatory = $true, ParameterSetName = 'WellKnownName', ValueFromPipelineByPropertyName = $true)]
                [String]$WellKnownSIDName,
                [Parameter(Mandatory = $false, ParameterSetName = 'WellKnownName')]
                [Switch]$WellKnownToNTAccount
            )
            process
            {
            }
        }

        function Get-UserProfiles
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String[]]$ExcludeNTAccount,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExcludeSystemProfiles,
                [Parameter(Mandatory = $false)]
                [Boolean]$ExcludeServiceProfiles,
                [Parameter(Mandatory = $false)]
                [Switch]$ExcludeDefaultUser
            )
        }

        function Get-FileVersion
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$File,
                [Parameter(Mandatory = $false)]
                [Switch]$ProductVersion,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function New-Shortcut
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String]$Path,
                [Parameter(Mandatory = $true)]
                [String]$TargetPath,
                [Parameter(Mandatory = $false)]
                [String]$Arguments,
                [Parameter(Mandatory = $false)]
                [String]$IconLocation,
                [Parameter(Mandatory = $false)]
                [Int32]$IconIndex,
                [Parameter(Mandatory = $false)]
                [String]$Description,
                [Parameter(Mandatory = $false)]
                [String]$WorkingDirectory,
                [Parameter(Mandatory = $false)]
                [String]$WindowStyle,
                [Parameter(Mandatory = $false)]
                [Switch]$RunAsAdmin,
                [Parameter(Mandatory = $false)]
                [String]$Hotkey,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Set-Shortcut
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding(DefaultParameterSetName = 'Default')]
            param (
                [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ParameterSetName = 'Default')]
                [String]$Path,
                [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ParameterSetName = 'Pipeline')]
                [Hashtable]$PathHash,
                [Parameter(Mandatory = $false)]
                [String]$TargetPath,
                [Parameter(Mandatory = $false)]
                [String]$Arguments,
                [Parameter(Mandatory = $false)]
                [String]$IconLocation,
                [Parameter(Mandatory = $false)]
                [String]$IconIndex,
                [Parameter(Mandatory = $false)]
                [String]$Description,
                [Parameter(Mandatory = $false)]
                [String]$WorkingDirectory,
                [Parameter(Mandatory = $false)]
                [String]$WindowStyle,
                [Parameter(Mandatory = $false)]
                [System.Nullable[Boolean]]$RunAsAdmin,
                [Parameter(Mandatory = $false)]
                [String]$Hotkey,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
            process
            {
            }
        }

        function Get-Shortcut
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Execute-ProcessAsUser
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$UserName,
                [Parameter(Mandatory = $true)]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [String]$TempPath,
                [Parameter(Mandatory = $false)]
                [String]$Parameters,
                [Parameter(Mandatory = $false)]
                [Switch]$SecureParameters,
                [Parameter(Mandatory = $false)]
                [String]$RunLevel,
                [Parameter(Mandatory = $false)]
                [Switch]$Wait,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [String]$WorkingDirectory,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Update-Desktop
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }
        Set-Alias -Name 'Refresh-Desktop' -Value 'Update-Desktop' -Scope 'Script' -Force -ErrorAction 'SilentlyContinue'

        function Update-SessionEnvironmentVariables
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Switch]$LoadLoggedOnUserEnvironmentVariables,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }
        Set-Alias -Name 'Refresh-SessionEnvironmentVariables' -Value 'Update-SessionEnvironmentVariables' -Scope 'Script' -Force -ErrorAction 'SilentlyContinue'

        function Get-SchedulerTask
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$TaskName,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }
        If (-not (Get-Command -Name 'Get-ScheduledTask' -ErrorAction 'SilentlyContinue'))
        {
            New-Alias -Name 'Get-ScheduledTask' -Value 'Get-SchedulerTask'
        }

        function Block-AppExecution
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String[]]$ProcessName
            )
        }

        function Unblock-AppExecution
        {
            [CmdletBinding()]
            param (
            )
        }

        function Get-DeferHistory
        {
            [CmdletBinding()]
            param (
            )
        }

        function Set-DeferHistory
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$deferTimesRemaining,
                [Parameter(Mandatory = $false)]
                [String]$deferDeadline
            )
        }

        function Get-UniversalDate
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$DateTime,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-RunningProcesses
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false, Position = 0)]
                [PSObject[]]$ProcessObjects,
                [Parameter(Mandatory = $false, Position = 1)]
                [Switch]$DisableLogging
            )
        }

        function Show-InstallationWelcome
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding(DefaultParametersetName = 'None')]
            param (
                [Parameter(Mandatory = $false)]
                [String]$CloseApps,
                [Parameter(Mandatory = $false)]
                [Switch]$Silent,
                [Parameter(Mandatory = $false)]
                [Int32]$CloseAppsCountdown,
                [Parameter(Mandatory = $false)]
                [Int32]$ForceCloseAppsCountdown,
                [Parameter(Mandatory = $false)]
                [Switch]$PromptToSave,
                [Parameter(Mandatory = $false)]
                [Switch]$PersistPrompt,
                [Parameter(Mandatory = $false)]
                [Switch]$BlockExecution,
                [Parameter(Mandatory = $false)]
                [Switch]$AllowDefer,
                [Parameter(Mandatory = $false)]
                [Switch]$AllowDeferCloseApps,
                [Parameter(Mandatory = $false)]
                [Int32]$DeferTimes,
                [Parameter(Mandatory = $false)]
                [Int32]$DeferDays,
                [Parameter(Mandatory = $false)]
                [String]$DeferDeadline,
                [Parameter(ParameterSetName = 'CheckDiskSpaceParameterSet', Mandatory = $true)]
                [Switch]$CheckDiskSpace,
                [Parameter(ParameterSetName = 'CheckDiskSpaceParameterSet', Mandatory = $false)]
                [Int32]$RequiredDiskSpace,
                [Parameter(Mandatory = $false)]
                [Boolean]$MinimizeWindows,
                [Parameter(Mandatory = $false)]
                [Boolean]$TopMost,
                [Parameter(Mandatory = $false)]
                [Int32]$ForceCountdown,
                [Parameter(Mandatory = $false)]
                [Switch]$CustomText
            )
        }

        function Show-WelcomePrompt
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$ProcessDescriptions,
                [Parameter(Mandatory = $false)]
                [Int32]$CloseAppsCountdown,
                [Parameter(Mandatory = $false)]
                [Boolean]$ForceCloseAppsCountdown,
                [Parameter(Mandatory = $false)]
                [Boolean]$PersistPrompt,
                [Parameter(Mandatory = $false)]
                [Switch]$AllowDefer,
                [Parameter(Mandatory = $false)]
                [String]$DeferTimes,
                [Parameter(Mandatory = $false)]
                [String]$DeferDeadline,
                [Parameter(Mandatory = $false)]
                [Boolean]$MinimizeWindows,
                [Parameter(Mandatory = $false)]
                [Boolean]$TopMost,
                [Parameter(Mandatory = $false)]
                [Int32]$ForceCountdown,
                [Parameter(Mandatory = $false)]
                [Switch]$CustomText
            )
        }

        function Show-InstallationRestartPrompt
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Int32]$CountdownSeconds,
                [Parameter(Mandatory = $false)]
                [Int32]$CountdownNoHideSeconds,
                [Parameter(Mandatory = $false)]
                [Boolean]$NoSilentRestart,
                [Parameter(Mandatory = $false)]
                [Switch]$NoCountdown,
                [Parameter(Mandatory = $false)]
                [Int32]$SilentCountdownSeconds,
                [Parameter(Mandatory = $false)]
                [Boolean]$TopMost
            )
        }

        function Show-BalloonTip
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String]$BalloonTipText,
                [Parameter(Mandatory = $false, Position = 1)]
                [String]$BalloonTipTitle,
                [Parameter(Mandatory = $false, Position = 2)]
                [Windows.Forms.ToolTipIcon]$BalloonTipIcon,
                [Parameter(Mandatory = $false, Position = 3)]
                [Int32]$BalloonTipTime,
                [Parameter(Mandatory = $false, Position = 4)]
                [Switch]$NoWait
            )
        }

        function Show-InstallationProgress
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [String]$StatusMessage,
                [Parameter(Mandatory = $false)]
                [String]$WindowLocation,
                [Parameter(Mandatory = $false)]
                [Boolean]$TopMost,
                [Parameter(Mandatory = $false)]
                [Switch]$Quiet
            )
        }

        function Close-InstallationProgress
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Int32]$WaitingTime
            )
        }

        function Set-PinnedApplication
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Action,
                [Parameter(Mandatory = $true)]
                [String]$FilePath
            )
        }

        function Get-IniValue
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$FilePath,
                [Parameter(Mandatory = $true)]
                [String]$Section,
                [Parameter(Mandatory = $true)]
                [String]$Key,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Set-IniValue
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$FilePath,
                [Parameter(Mandatory = $true)]
                [String]$Section,
                [Parameter(Mandatory = $true)]
                [String]$Key,
                [Parameter(Mandatory = $true)]
                [AllowNull()]
                $Value,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-PEFileArchitecture
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [IO.FileInfo[]]$FilePath,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru
            )
            process
            {
            }
        }

        function Invoke-RegisterOrUnregisterDLL
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$FilePath,
                [Parameter(Mandatory = $false)]
                [String]$DLLAction,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }
        Set-Alias -Name 'Register-DLL' -Value 'Invoke-RegisterOrUnregisterDLL' -Scope 'Script' -Force -ErrorAction 'SilentlyContinue'
        Set-Alias -Name 'Unregister-DLL' -Value 'Invoke-RegisterOrUnregisterDLL' -Scope 'Script' -Force -ErrorAction 'SilentlyContinue'

        function Invoke-ObjectMethod
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding(DefaultParameterSetName = 'Positional')]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [Object]$InputObject,
                [Parameter(Mandatory = $true, Position = 1)]
                [String]$MethodName,
                [Parameter(Mandatory = $false, Position = 2, ParameterSetName = 'Positional')]
                [Object[]]$ArgumentList,
                [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Named')]
                [Hashtable]$Parameter
            )
        }

        function Get-ObjectProperty
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [Object]$InputObject,
                [Parameter(Mandatory = $true, Position = 1)]
                [String]$PropertyName,
                [Parameter(Mandatory = $false, Position = 2)]
                [Object[]]$ArgumentList
            )
        }

        function Get-MsiTableProperty
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding(DefaultParameterSetName = 'TableInfo')]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Path,
                [Parameter(Mandatory = $false)]
                [String[]]$TransformPath,
                [Parameter(Mandatory = $false, ParameterSetName = 'TableInfo')]
                [String]$Table,
                [Parameter(Mandatory = $false, ParameterSetName = 'TableInfo')]
                [Int32]$TablePropertyNameColumnNum,
                [Parameter(Mandatory = $false, ParameterSetName = 'TableInfo')]
                [Int32]$TablePropertyValueColumnNum,
                [Parameter(Mandatory = $true, ParameterSetName = 'SummaryInfo')]
                [Switch]$GetSummaryInformation,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Set-MsiProperty
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [__ComObject]$DataBase,
                [Parameter(Mandatory = $true)]
                [String]$PropertyName,
                [Parameter(Mandatory = $true)]
                [String]$PropertyValue,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function New-MsiTransform
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$MsiPath,
                [Parameter(Mandatory = $false)]
                [String]$ApplyTransformPath,
                [Parameter(Mandatory = $false)]
                [String]$NewTransformPath,
                [Parameter(Mandatory = $true)]
                [Hashtable]$TransformProperties,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Test-MSUpdates
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0)]
                [String]$KBNumber,
                [Parameter(Mandatory = $false, Position = 1)]
                [Boolean]$ContinueOnError
            )
        }

        function Install-MSUpdates
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Directory
            )
        }

        function Get-WindowTitle
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, ParameterSetName = 'SearchWinTitle')]
                [AllowEmptyString()]
                [String]$WindowTitle,
                [Parameter(Mandatory = $true, ParameterSetName = 'GetAllWinTitles')]
                [Switch]$GetAllWindowTitles,
                [Parameter(Mandatory = $false)]
                [Switch]$DisableFunctionLogging
            )
        }

        function Send-Keys
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false, Position = 0)]
                [AllowEmptyString()]
                [String]$WindowTitle,
                [Parameter(Mandatory = $false, Position = 1)]
                [Switch]$GetAllWindowTitles,
                [Parameter(Mandatory = $false, Position = 2)]
                [IntPtr]$WindowHandle,
                [Parameter(Mandatory = $false, Position = 3)]
                [String]$Keys,
                [Parameter(Mandatory = $false, Position = 4)]
                [Int32]$WaitSeconds
            )
        }

        function Test-Battery
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru
            )
        }

        function Test-NetworkConnection
        {
            [CmdletBinding()]
            param (
            )
        }

        function Test-PowerPoint
        {
            [CmdletBinding()]
            param (
            )
        }

        function Invoke-SCCMTask
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$ScheduleID,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Install-SCCMSoftwareUpdates
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Int32]$SoftwareUpdatesScanWaitInSeconds,
                [Parameter(Mandatory = $false)]
                [Timespan]$WaitForPendingUpdatesTimeout,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Update-GroupPolicy
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Enable-TerminalServerInstallMode
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Disable-TerminalServerInstallMode
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Set-ActiveSetup
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
                [String]$StubExePath,
                [Parameter(Mandatory = $false, ParameterSetName = 'Create')]
                [String]$Arguments,
                [Parameter(Mandatory = $false, ParameterSetName = 'Create')]
                [String]$Description,
                [Parameter(Mandatory = $false)]
                [String]$Key,
                [Parameter(Mandatory = $false)]
                [Switch]$Wow6432Node,
                [Parameter(Mandatory = $false, ParameterSetName = 'Create')]
                [String]$Version,
                [Parameter(Mandatory = $false, ParameterSetName = 'Create')]
                [String]$Locale,
                [Parameter(Mandatory = $false, ParameterSetName = 'Create')]
                [Switch]$DisableActiveSetup,
                [Parameter(Mandatory = $true, ParameterSetName = 'Purge')]
                [Switch]$PurgeActiveSetupKey,
                [Parameter(Mandatory = $false, ParameterSetName = 'Create')]
                [Boolean]$ExecuteForCurrentUser,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Test-ServiceExists
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [String]$ComputerName,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Stop-ServiceAndDependencies
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [String]$ComputerName,
                [Parameter(Mandatory = $false)]
                [Switch]$SkipServiceExistsTest,
                [Parameter(Mandatory = $false)]
                [Switch]$SkipDependentServices,
                [Parameter(Mandatory = $false)]
                [Timespan]$PendingStatusWait,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Start-ServiceAndDependencies
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [String]$ComputerName,
                [Parameter(Mandatory = $false)]
                [Switch]$SkipServiceExistsTest,
                [Parameter(Mandatory = $false)]
                [Switch]$SkipDependentServices,
                [Parameter(Mandatory = $false)]
                [Timespan]$PendingStatusWait,
                [Parameter(Mandatory = $false)]
                [Switch]$PassThru,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-ServiceStartMode
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [String]$ComputerName,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Set-ServiceStartMode
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true)]
                [String]$Name,
                [Parameter(Mandatory = $false)]
                [String]$ComputerName,
                [Parameter(Mandatory = $true)]
                [String]$StartMode,
                [Parameter(Mandatory = $false)]
                [Boolean]$ContinueOnError
            )
        }

        function Get-LoggedOnUser
        {
            [CmdletBinding()]
            param (
            )
        }

        function Get-PendingReboot
        {
            [CmdletBinding()]
            param (
            )
        }

        function Set-ItemPermission
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter( Mandatory = $true, Position = 0, ParameterSetName = 'DisableInheritance' )]
                [Parameter( Mandatory = $true, Position = 0, ParameterSetName = 'EnableInheritance' )]
                [Alias('File', 'Folder')]
                [String]$Path,
                [Parameter( Mandatory = $true, Position = 1, ParameterSetName = 'DisableInheritance')]
                [Alias('Username', 'Users', 'SID', 'Usernames')]
                [String[]]$User,
                [Parameter( Mandatory = $true, Position = 2, ParameterSetName = 'DisableInheritance')]
                [Alias('Acl', 'Grant', 'Permissions', 'Deny')]
                [String[]]$Permission,
                [Parameter( Mandatory = $false, Position = 3, ParameterSetName = 'DisableInheritance')]
                [Alias('AccessControlType')]
                [String]$PermissionType,
                [Parameter( Mandatory = $false, Position = 4, ParameterSetName = 'DisableInheritance')]
                [String[]]$Inheritance,
                [Parameter( Mandatory = $false, Position = 5, ParameterSetName = 'DisableInheritance')]
                [String]$Propagation,
                [Parameter( Mandatory = $false, Position = 6, ParameterSetName = 'DisableInheritance')]
                [Alias('ApplyMethod', 'ApplicationMethod')]
                [String]$Method,
                [Parameter( Mandatory = $true, Position = 1, ParameterSetName = 'EnableInheritance')]
                [Switch]$EnableInheritance
            )
        }

        function Copy-ContentToCache
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false, Position = 0)]
                [String]$Path
            )
        }

        function Remove-ContentFromCache
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $false, Position = 0)]
                [String]$Path
            )
        }

        function Configure-EdgeExtension
        {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Rules need not apply to these dummy function definitions')]
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
                [Switch]$Add,
                [Parameter(Mandatory = $true, ParameterSetName = 'Remove')]
                [Switch]$Remove,
                [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
                [Parameter(Mandatory = $true, ParameterSetName = 'Remove')]
                [String]$ExtensionID,
                [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
                [String]$InstallationMode,
                [Parameter(Mandatory = $true, ParameterSetName = 'Add')]
                [String]$UpdateUrl,
                [Parameter(Mandatory = $false, ParameterSetName = 'Add')]
                [String]$MinimumVersionRequired
            )
        }
        #endregion

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
                'NewFunction' = 'Close-ADTSession'
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
                    'MinimizeWindows' = { if ($_ -eq '$true') { '-MinimizeWindows' } }
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
            'Get-RunningProcesses' = @{
                'NewFunction' = 'Get-ADTRunningProcesses'
                'TransformParameters' = @{
                    'DisableLogging' = '-InformationAction SilentlyContinue'
                }
            }
            'Show-InstallationWelcome' = @{
                'NewFunction' = 'Show-ADTInstallationWelcome'
                'TransformParameters' = @{
                    'MinimizeWindows' = { if ($_ -eq '$true') { '-MinimizeWindows' } }
                    'TopMost' = { if ($_ -eq '$false') { '-NotTopMost' } }
                    'CloseAppsCountdown' = { "-CloseProcessesCountdown $_" }
                    'ForceCloseAppsCountdown' = { "-ForceCloseProcessesCountdown $_" }
                    'AllowDeferCloseApps' = '-AllowDeferCloseProcesses' # Should inspect switch values here in case of -Switch:$false
                    'CloseApps' = {
                        $quoteChar = if ($boundParameters.CloseApps.Value.StringConstantType -eq 'DoubleQuoted') { '"' } else { "'" }
                        $closeProcesses = $_.ToString().Trim('"').Trim("'") -split ',' | & {
                            process
                            {
                                $name, $description = $_ -split '='
                                if ($description)
                                {
                                    "@{ Name = $quoteChar$($name)$quoteChar; Description = $quoteChar$($description)$quoteChar }"
                                }
                                else
                                {
                                    "$quoteChar$($name)$quoteChar"
                                }
                            }
                        }
                        $closeProcesses = $closeProcesses -join ', '
                        "-CloseProcesses $closeProcesses"
                    }
                }
            }
            'Get-WindowTitle' = @{
                'NewFunction' = 'Get-ADTWindowTitle'
                'TransformParameters' = @{
                    'DisableFunctionLogging' = '-InformationAction SilentlyContinue' # Should inspect switch values here in case of -Switch:$false
                }
                'RemoveParameters' = @(
                    'GetAllWindowTitles'
                )
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
                'TransformParameters' = @{
                    'Path' = { "-LiteralPath $_" }
                }
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
                    'Path' = { "-LiteralPath $_" }
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
                'NewFunction' = {
                    if ($boundParameters.ContainsKey('ErrorRecord')) { 'Resolve-ADTErrorRecord' } else { '$Error[0] | Resolve-ADTErrorRecord' }
                }
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
                'RemoveParameters' = @(
                    'GetErrorRecord'
                    'GetErrorInvocation'
                    'GetErrorException'
                    'GetErrorInnerException'
                )
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
                    'UseShellExecute' = { if ($_ -eq '$true') { '-UseShellExecute' } }
                    'WindowStyle' = { if (!$boundParameters.CreateNoWindow.ConstantValue) { "-WindowStyle $_" } } # Remove WindowStyle if CreateNoWindow is set
                    'MsiExecWaitTime' = { "-MsiExecWaitTime ([System.TimeSpan]::FromSeconds($_))" }
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
                    'Path' = { if ($_ -match '^[''"]?\{?([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}?[''"]?$') { "-ProductCode $_" } else { "-FilePath $_" } }
                    'Arguments' = { "-ArgumentList $_" }
                    'Parameters' = { "-ArgumentList $_" }
                    'AddParameters' = { "-AdditionalArgumentList $_" }
                    'SecureParameters' = '-SecureArgumentList' # Should inspect switch values here in case of -Switch:$false
                    'Transform' = { "-Transforms $(if ($_ -match "^'") { $_ -replace ';', "','" } elseif ($_ -match '^"') { $_ -replace ';', '","' } else { $_ })" }
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
                    'AddParameters' = { "-AdditionalArgumentList $_" }
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
                    'Key' = { "-LiteralPath $_" }
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
                    'Key' = { "-LiteralPath $_" }
                    'Value' = { "-Name $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Install-MSUpdates' = @{
                'NewFunction' = 'Install-ADTMSUpdates'
            }
            'Get-SchedulerTask' = @{
                'NewFunction' = 'Get-ScheduledTask'
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
                    'File' = { "-LiteralPath $_" }
                    'Folder' = { "-LiteralPath $_" }
                    'Path' = { "-LiteralPath $_" }
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
                'TransformParameters' = @{
                    'WaitSeconds' = { "-WaitDuration ([System.TimeSpan]::FromSeconds($_))" }
                }
            }
            'Get-Shortcut' = @{
                'NewFunction' = 'Get-ADTShortcut'
                'TransformParameters' = @{
                    'Path' = { "-LiteralPath $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Set-Shortcut' = @{
                'NewFunction' = 'Set-ADTShortcut'
                'TransformParameters' = @{
                    'Path' = { "-LiteralPath $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'New-Shortcut' = @{
                'NewFunction' = 'New-ADTShortcut'
                'TransformParameters' = @{
                    'Path' = { "-LiteralPath $_" }
                    'RunAsAdmin' = { if ($_ -eq '$true') { '-RunAsAdmin' } }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Execute-ProcessAsUser' = @{
                'NewFunction' = 'Start-ADTProcessAsUser'
                'AddParameters' = @{
                    'NoWait' = { if (!$boundParameters.Wait.ConstantValue) { '-NoWait' } }
                }
                'TransformParameters' = @{
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
                'RemoveParameters' = @(
                    'Wait'
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
                    'Path' = { "-LiteralPath $_" }
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
                'TransformParameters' = @{
                    'MsiErrorCode' = { "-MsiExitCode $_" }
                }
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
                    'FilePath' = { "-LiteralPath $_" }
                    'Path' = { "-LiteralPath $_" }
                    'ContinueOnError' = { if ($_ -eq '$true') { '-ErrorAction SilentlyContinue' } else { '-ErrorAction Stop' } }
                }
            }
            'Test-IsMutexAvailable' = @{
                'NewFunction' = 'Test-ADTMutexAvailability'
                'TransformParameters' = @{
                    'MutexWaitTimeInMilliseconds' = { "-MutexWaitTime ([System.TimeSpan]::FromMilliseconds($_))" }
                }
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
            deployAppScriptDate = $null
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
            configBalloonTextComplete = '(Get-ADTStringTable).BalloonText.Complete'
            configBalloonTextError = '(Get-ADTStringTable).BalloonText.Error'
            configBalloonTextFastRetry = '(Get-ADTStringTable).BalloonText.FastRetry'
            configBalloonTextRestartRequired = '(Get-ADTStringTable).BalloonText.RestartRequired'
            configBalloonTextStart = '(Get-ADTStringTable).BalloonText.Start'
            configBannerIconBannerName = '(Get-ADTConfig).Assets.Banner'
            configBannerIconFileName = $null
            configBannerLogoImageFileName = '(Get-ADTConfig).Assets.Logo'
            configBlockExecutionMessage = '(Get-ADTStringTable).BlockExecution.Message'
            configClosePromptButtonClose = '(Get-ADTStringTable).ClosePrompt.ButtonClose'
            configClosePromptButtonContinue = '(Get-ADTStringTable).ClosePrompt.ButtonContinue'
            configClosePromptButtonContinueTooltip = '(Get-ADTStringTable).ClosePrompt.ButtonContinueTooltip'
            configClosePromptButtonDefer = '(Get-ADTStringTable).ClosePrompt.ButtonDefer'
            configClosePromptCountdownMessage = '(Get-ADTStringTable).ClosePrompt.CountdownMessage'
            configClosePromptMessage = '(Get-ADTStringTable).ClosePrompt.Message'
            configConfigDate = $null
            configConfigDetails = $null
            configConfigVersion = $null
            configDeferPromptDeadline = '(Get-ADTStringTable).DeferPrompt.Deadline'
            configDeferPromptExpiryMessage = '(Get-ADTStringTable).DeferPrompt.ExpiryMessage'
            configDeferPromptRemainingDeferrals = '(Get-ADTStringTable).DeferPrompt.RemainingDeferrals'
            configDeferPromptWarningMessage = '(Get-ADTStringTable).DeferPrompt.WarningMessage'
            configDeferPromptWelcomeMessage = '(Get-ADTStringTable).DeferPrompt.WelcomeMessage'
            configDeploymentTypeInstall = '(Get-ADTStringTable).DeploymentType.Install'
            configDeploymentTypeRepair = '(Get-ADTStringTable).DeploymentType.Repair'
            configDeploymentTypeUnInstall = '(Get-ADTStringTable).DeploymentType.Uninstall'
            configDiskSpaceMessage = '(Get-ADTStringTable).DiskSpace.Message'
            configInstallationDeferExitCode = '(Get-ADTConfig).UI.DeferExitCode'
            configInstallationPersistInterval = '(Get-ADTConfig).UI.DefaultPromptPersistInterval'
            configInstallationPromptToSave = '(Get-ADTConfig).UI.PromptToSaveTimeout'
            configInstallationRestartPersistInterval = '(Get-ADTConfig).UI.RestartPromptPersistInterval'
            configInstallationUIExitCode = '(Get-ADTConfig).UI.DefaultExitCode'
            configInstallationUILanguageOverride = '(Get-ADTConfig).UI.LanguageOverride'
            configInstallationUITimeout = '(Get-ADTConfig).UI.DefaultTimeout'
            configInstallationWelcomePromptDynamicRunningProcessEvaluation = '(Get-ADTConfig).UI.DynamicProcessEvaluation'
            configInstallationWelcomePromptDynamicRunningProcessEvaluationInterval = '(Get-ADTConfig).UI.DynamicProcessEvaluationInterval'
            configMSIInstallParams = '(Get-ADTConfig).MSI.InstallParams'
            configMSILogDir = 'if ($isAdmin) { (Get-ADTConfig).MSI.LogPath } else { (Get-ADTConfig).MSI.LogPathNoAdminRights }'
            configMSILoggingOptions = '(Get-ADTConfig).MSI.LoggingOptions'
            configMSIMutexWaitTime = '(Get-ADTConfig).MSI.MutexWaitTime'
            configMSISilentParams = '(Get-ADTConfig).MSI.SilentParams'
            configMSIUninstallParams = '(Get-ADTConfig).MSI.UninstallParams'
            configProgressMessageInstall = '(Get-ADTStringTable).Progress.MessageInstall'
            configProgressMessageRepair = '(Get-ADTStringTable).Progress.MessageRepair'
            configProgressMessageUninstall = '(Get-ADTStringTable).Progress.MessageUninstall'
            configRestartPromptButtonRestartLater = '(Get-ADTStringTable).RestartPrompt.ButtonRestartLater'
            configRestartPromptButtonRestartNow = '(Get-ADTStringTable).RestartPrompt.ButtonRestartNow'
            configRestartPromptMessage = '(Get-ADTStringTable).RestartPrompt.Message'
            configRestartPromptMessageRestart = '(Get-ADTStringTable).RestartPrompt.MessageRestart'
            configRestartPromptMessageTime = '(Get-ADTStringTable).RestartPrompt.MessageTime'
            configRestartPromptTimeRemaining = '(Get-ADTStringTable).RestartPrompt.TimeRemaining'
            configRestartPromptTitle = '(Get-ADTStringTable).RestartPrompt.Title'
            configShowBalloonNotifications = '(Get-ADTConfig).UI.BalloonNotifications'
            configToastAppName = '(Get-ADTConfig).UI.BalloonTitle'
            configToastDisable = '(Get-ADTConfig).UI.BalloonNotifications'
            configToolkitCachePath = '(Get-ADTConfig).Toolkit.CachePath'
            configToolkitCompressLogs = '(Get-ADTConfig).Toolkit.CompressLogs'
            configToolkitLogAppend = '(Get-ADTConfig).Toolkit.LogAppend'
            configToolkitLogDebugMessage = '(Get-ADTConfig).Toolkit.LogDebugMessage'
            configToolkitLogDir = 'if ($isAdmin) { (Get-ADTConfig).Toolkit.LogPath } else { (Get-ADTConfig).Toolkit.LogPathNoAdminRights }'
            configToolkitLogMaxHistory = '(Get-ADTConfig).Toolkit.LogMaxHistory'
            configToolkitLogMaxSize = '(Get-ADTConfig).Toolkit.LogMaxSize'
            configToolkitLogStyle = '(Get-ADTConfig).Toolkit.LogStyle'
            configToolkitLogWriteToHost = '(Get-ADTConfig).Toolkit.LogWriteToHost'
            configToolkitRegPath = '(Get-ADTConfig).Toolkit.RegPath'
            configToolkitRequireAdmin = '(Get-ADTConfig).Toolkit.RequireAdmin'
            configToolkitTempPath = 'if ($isAdmin) { (Get-ADTConfig).Toolkit.TempPath } else { (Get-ADTConfig).Toolkit.TempPathNoAdminRights }'
            configToolkitUseRobocopy = '(Get-ADTConfig).Toolkit.FileCopyMode -eq ''Robocopy'''
            configWelcomePromptCountdownMessage = '(Get-ADTStringTable).WelcomePrompt.Classic.CountdownMessage'
            configWelcomePromptCustomMessage = '(Get-ADTStringTable).WelcomePrompt.Classic.CustomMessage'
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
            IsOOBEComplete = 'Test-ADTOobeCompleted'
            IsTaskSchedulerHealthy = $null
            LocalPowerUsersGroup = $null
            LogFileInitialized = $null
            loggedOnUserTempPath = $null
            LogicalScreenHeight = $null
            LogTimeZoneBias = $null
            mainExitCode = $null
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

            # 1. Process all variable contents used by legacy functions
            foreach ($commandAst in $commandAsts)
            {
                $functionName = $commandAst.GetCommandName()
                $boundParameters = ($spBinder::BindCommand($commandAst, $true)).BoundParameters

                foreach ($boundParameter in $boundParameters.GetEnumerator())
                {
                    # Process all variables used that require transformation
                    $parameterName = $boundParameter.Key
                    $variableName = $boundParameter.Value.Value.VariablePath.UserPath

                    if ($variableName -and $functionMappings.$functionName.TransformParameters.$parameterName -is [ScriptBlock])
                    {
                        # Find the last assignment of the variable before the current command
                        [ScriptBlock]$variableAssignmentPredicate = {
                            param ([System.Management.Automation.Language.Ast]$Ast)
                            $Ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and $Ast.Left.Extent.Text -match "\`$$variableName$" -and ($Ast.Extent.StartLineNumber -lt $commandAst.Extent.StartLineNumber -or ($Ast.Extent.StartLineNumber -eq $commandAst.Extent.StartLineNumber -and $Ast.Extent.StartColumnNumber -lt $commandAst.Extent.StartColumnNumber))
                        }
                        [System.Management.Automation.Language.Ast]$variableAssignmentAst = $ScriptBlockAst.FindAll($variableAssignmentPredicate, $true) | Select-Object -Last 1

                        if ($variableAssignmentAst)
                        {
                            $newVariableContent = ForEach-Object -InputObject $variableAssignmentAst.Right.Extent.Text -Process $functionMappings[$functionName].TransformParameters[$parameterName]
                            $newVariableContent = $newVariableContent -replace '^-\w+\s+`?' # Remove -Parameter name + space, plus potential backtick/linebreak

                            $outputMessage = "Modify variable:`n$($variableAssignmentAst.Left.Extent.Text)` = $newVariableContent"

                            # Create a CorrectionExtent object for the suggested correction
                            $objParams = @{
                                TypeName = 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent'
                                ArgumentList = @(
                                    $variableAssignmentAst.Extent.StartLineNumber
                                    $variableAssignmentAst.Extent.EndLineNumber
                                    $variableAssignmentAst.Extent.StartColumnNumber
                                    $variableAssignmentAst.Extent.EndColumnNumber
                                    "$($variableAssignmentAst.Left.Extent.Text) = $newVariableContent"
                                    $MyInvocation.MyCommand.Definition
                                    'More information: https://psappdeploytoolkit.com/docs/reference/variables'
                                )
                            }
                            $correctionExtent = New-Object @objParams
                            $suggestedCorrections = New-Object System.Collections.ObjectModel.Collection[$($objParams.TypeName)]
                            $suggestedCorrections.Add($correctionExtent) | Out-Null

                            # Output the diagnostic record in the format expected by the ScriptAnalyzer
                            [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                                Message = $outputMessage
                                Extent = $variableAssignmentAst.Extent
                                RuleName = 'Measure-ADTCompatibility'
                                Severity = 'Warning'
                                RuleSuppressionID = 'ADTCompatibilitySuppression'
                                SuggestedCorrections = $suggestedCorrections
                            }
                        }
                    }

                    # Process all hashtable definitions that splat to legacy functions
                    if ($boundParameter.Value.Value.Splatted)
                    {
                        # Find the last assignment of the splat variable before the current command
                        [ScriptBlock]$splatPredicate = {
                            param ([System.Management.Automation.Language.Ast]$Ast)
                            $Ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and $Ast.Left.Extent.Text -match "\`$$variableName$" -and ($Ast.Extent.StartLineNumber -lt $commandAst.Extent.StartLineNumber -or ($Ast.Extent.StartLineNumber -eq $commandAst.Extent.StartLineNumber -and $Ast.Extent.StartColumnNumber -lt $commandAst.Extent.StartColumnNumber))
                        }
                        [System.Management.Automation.Language.Ast]$splatAst = $ScriptBlockAst.FindAll($splatPredicate, $true) | Select-Object -Last 1

                        if ($splatAst)
                        {
                            $splatModified = $false
                            $outputMessage = New-Object System.Text.StringBuilder
                            $outputMessage.AppendLine("Modify splat `$$variableName`:") | Out-Null

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

            # 2. Process all legacy variables
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

            # 3. Redefine legacy functions
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
                            elseif ($boundParameter.Key -match '^\d+$')
                            {
                                # This is an unrecognized positional parameter, pass through  as-is
                                $newParam = $boundParameter.Value.Value.Extent.Text
                            }
                            else
                            {
                                # This is a regular parameter, e.g. -Path 'xxx'
                                $newParam = "-$($boundParameter.Key)"
                                if (![string]::IsNullOrWhiteSpace($boundParameter.Value.Value.Extent.Text))
                                {
                                    $newParam += " $($boundParameter.Value.Value.Extent.Text)"
                                }
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
                $newCommand = $newFunction
                if ($newParams.Count -gt 0)
                {
                    $newCommand = $newCommand + ' ' + ($newParams -join ' ')
                }

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
