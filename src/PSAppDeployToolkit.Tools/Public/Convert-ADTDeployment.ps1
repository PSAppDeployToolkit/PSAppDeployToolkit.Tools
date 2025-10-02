#-----------------------------------------------------------------------------
#
# MARK: Convert-ADTDeployment
#
#-----------------------------------------------------------------------------
function Convert-ADTDeployment
{
    <#
    .SYNOPSIS
        Converts either a Deploy-Application.ps1 script, or a full application package to use the new folder structure and syntax required by PSAppDeployToolkit v4.

    .DESCRIPTION
        The variables and main code blocks are updated to the new syntax via PSScriptAnalyzer, then transferred to a fresh Invoke-AppDeployToolkit.ps1 script.

    .PARAMETER Path
        Path to the Deploy-Application.ps1 file or folder to analyze. If a folder is specified, it must contain the Deploy-Application.ps1 script and the AppDeployToolkit folder.

    .PARAMETER Destination
        Path to the output file or folder. If not specified it will default to creating either a Invoke-AppDeployToolkit.ps1 file or FolderName_Converted folder under the parent folder of the supplied Path value.

    .PARAMETER Show
        Opens the newly created output in Windows Explorer.

    .PARAMETER Force
        Overwrite the output path if it already exists.

    .PARAMETER PassThru
        Pass the output file or folder to the pipeline.

    .INPUTS
        System.String

        You can pipe script files or folders to this function.

    .OUTPUTS
        System.IO.FileInfo / System.IO.DirectoryInfo

        Returns the file or folder to the pipeline if -PassThru is specified.

    .EXAMPLE
        Convert-ADTDeployment -Path .\Deploy-Application.ps1

        This example converts Deploy-Application.ps1 into Invoke-AppDeployToolkit.ps1 in the same folder.

	.EXAMPLE
        Convert-ADTDeployment -Path .\PackageFolder

        This example converts PackageFolder into PackageFolder_Converted in the same folder.

	.EXAMPLE
        $ConvertedPackages = Get-ChildItem -Directory | Convert-ADTDeployment -Destination C:\Temp\ConvertedPackages -Force -PassThru

        Get all folders in the current directory and convert them to v4 packages in C:\Temp\ConvertedPackages, overwriting existing files and storing the new package info in $ConvertedPackages.

    .NOTES
        An active ADT session is NOT required to use this function.
        Requires PSScriptAnalyzer module 1.24.0 or later. To install:

        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
        Install-Module -Name PSScriptAnalyzer -Scope AllUsers

        Tags: psadt
        Website: https://psappdeploytoolkit.com
        Copyright: (C) 2025 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham, Muhammad Mashwani, Mitch Richters, Dan Gough).
        License: https://opensource.org/license/lgpl-3-0

    .LINK
        https://psappdeploytoolkit.com
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName')]
        [ValidateScript({
                if (!(Test-Path -LiteralPath $_))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'The specified path does not exist.'))
                }
                elseif ((Test-Path -LiteralPath $_ -PathType Leaf) -and [System.IO.Path]::GetExtension($_) -ne '.ps1')
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'The specified file is not a PowerShell script.'))
                }
                elseif ((Test-Path -LiteralPath $_ -PathType Container) -and -not (Test-Path -LiteralPath (Join-Path -Path $_ -ChildPath 'Deploy-Application.ps1') -PathType Leaf))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'Deploy-Application.ps1 not found in the specified path.'))
                }
                elseif ((Test-Path -LiteralPath $_ -PathType Container) -and -not (Test-Path -LiteralPath (Join-Path -Path $_ -ChildPath 'AppDeployToolkit') -PathType Container))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'AppDeployToolkit folder not found in the specified path.'))
                }
                return ![System.String]::IsNullOrWhiteSpace($_)
            })]
        [System.String]$Path,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination = (Split-Path -Path $Path -Parent),

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$Show,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$Force,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$PassThru
    )

    begin
    {
        # Initialize function.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $scriptReplacements = @(
            @{
                v4FunctionName = 'Install-ADTDeployment'
                v3IfConditionMatch = '^\$(adtSession\.)?deploymentType -ine ''Uninstall'''
            },
            @{
                v4FunctionName = 'Uninstall-ADTDeployment'
                v3IfConditionMatch = '^\$(adtSession\.)?deploymentType -ieq ''Uninstall'''
            },
            @{
                v4FunctionName = 'Repair-ADTDeployment'
                v3IfConditionMatch = '^\$(adtSession\.)?deploymentType -ieq ''Repair'''
            }
        )

        $variableReplacements = @('appVendor', 'appName', 'appVersion', 'appArch', 'appLang', 'appRevision', 'appScriptVersion', 'appScriptAuthor', 'installName', 'installTitle')

        $customRulePath = [System.IO.Path]::Combine($MyInvocation.MyCommand.Module.ModuleBase, 'PSScriptAnalyzer\Measure-ADTCompatibility.psm1')

        $spBinder = [System.Management.Automation.Language.StaticParameterBinder]
    }

    process
    {
        try
        {
            try
            {
                $Path = (Resolve-Path -LiteralPath $Path).Path
                $Destination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination) # This method resolves relative paths that might not exist and also accepts PSPaths unlike [System.IO.Path]::GetFullPath()
                $tempFolderName = "Convert-ADTDeployment_$([System.IO.Path]::GetRandomFileName().Replace('.', ''))"
                $tempFolderPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), $tempFolderName)

                if ($Path -like '*.ps1')
                {
                    Write-Verbose -Message "Input path is a .ps1 file: [$Path]"

                    # Update destination path with a specific filename if current value does not end in .ps1
                    $Destination = if ($Destination -like '*.ps1') { $Destination } else { [System.IO.Path]::Combine($Destination, 'Invoke-AppDeployToolkit.ps1') }
                    Write-Verbose -Message "Destination path: [$Destination]"

                    # Halt if the destination file already exists and -Force is not specified
                    if (!$Force -and [System.IO.File]::Exists($Destination))
                    {
                        $naerParams = @{
                            Exception = [System.IO.IOException]::new("File [$Destination] already exists.")
                            Category = [System.Management.Automation.ErrorCategory]::ResourceExists
                            ErrorId = 'FileAlreadyExistsError'
                            TargetObject = $Path
                            RecommendedAction = 'Use the -Force parameter to overwrite the existing file.'
                        }
                        Write-Error -ErrorRecord (New-ADTErrorRecord @naerParams)
                    }

                    if ($Path -notmatch '(?<=^|\\)(Deploy-Application\.ps1|Invoke-AppDeployToolkit\.ps1)$')
                    {
                        Write-Warning -Message "This function is designed to convert PSAppDeployToolkit deployment scripts such as Deploy-Application.ps1 or Invoke-AppDeployToolkit.ps1."
                    }

                    # Create the temp folder
                    Write-Verbose -Message "Creating ADT Template in [$tempFolderPath]"
                    New-ADTTemplate -Destination ([System.IO.Path]::GetTempPath()) -Name $tempFolderName

                    # Create a temp copy of the script to run ScriptAnalyzer fixes on - prefix filename with _ if it's named Invoke-AppDeployToolkit.ps1
                    $inputScriptPath = if ($Path -match '(?<=^|\\)Invoke-AppDeployToolkit.ps1$')
                    {
                        [System.IO.Path]::Combine($tempFolderPath, "_$([System.IO.Path]::GetFileName($Path))")
                    }
                    else
                    {
                        [System.IO.Path]::Combine($tempFolderPath, [System.IO.Path]::GetFileName($Path))
                    }

                    Write-Verbose -Message "Creating copy of [$Path] as [$inputScriptPath]"
                    Copy-Item -LiteralPath $Path -Destination $inputScriptPath -Force
                }
                else
                {
                    Write-Verbose -Message "Input path is a folder: [$Path]"

                    # Re-use the same folder name with _Converted suffix for the new folder
                    $folderName = "$(Split-Path -Path $Path -Leaf)_Converted"

                    # Update destination path to append this new folder name. If Destination is empty, it would mean that Path was something like C:\ with no parent, so just append the folder name to Path instead.
                    $Destination = if ([string]::IsNullOrEmpty($Destination))
                    {
                        [System.IO.Path]::Combine($Path, $folderName)
                    }
                    else
                    {
                        [System.IO.Path]::Combine($Destination, $folderName)
                    }
                    Write-Verbose -Message "Destination path: [$Destination]"

                    # Halt if the destination folder already exists and is not empty and -Force is not specified
                    if (!$Force -and [System.IO.Directory]::Exists($Destination) -and ([System.IO.Directory]::GetFiles($Destination) -or [System.IO.Directory]::GetDirectories($Destination)))
                    {
                        $naerParams = @{
                            Exception = [System.IO.IOException]::new("Folder [$finalDestination] already exists and is not empty.")
                            Category = [System.Management.Automation.ErrorCategory]::ResourceExists
                            ErrorId = 'FolderAlreadyExistsError'
                            TargetObject = $Path
                            RecommendedAction = 'Use the -Force parameter to overwrite the existing folder.'
                        }
                        Write-Error -ErrorRecord (New-ADTErrorRecord @naerParams)
                    }

                    Write-Verbose -Message "Creating ADT Template in [$tempFolderPath]"
                    New-ADTTemplate -Destination ([System.IO.Path]::GetTempPath()) -Name $tempFolderName

                    Write-Verbose -Message "Creating copy of [$Path\Deploy-Application.ps1] as [$tempFolderPath\Deploy-Application.ps1]"
                    $inputScriptPath = (Copy-Item -LiteralPath ([System.IO.Path]::Combine($Path, 'Deploy-Application.ps1')) -Destination $tempFolderPath -Force -PassThru).FullName
                }

                # Set the path of our v4 template script
                $outputScriptPath = [System.IO.Path]::Combine($tempFolderPath, 'Invoke-AppDeployToolkit.ps1')

                # First run the fixes on the input script to update function names and variables
                Write-Verbose -Message "Running ScriptAnalyzer fixes on [$inputScriptPath]"
                Invoke-ScriptAnalyzer -Path $inputScriptPath -CustomRulePath $customRulePath -Fix | Out-Null

                # Parse the input script and find the if statement that contains the deployment code
                $inputScriptContent = Get-Content -Path $inputScriptPath -Raw
                $inputScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($inputScriptContent, [ref]$null, [ref]$null)

                $ifStatement = $inputScriptAst.Find({
                        param ($ast)
                        $ast -is [System.Management.Automation.Language.IfStatementAst] -and $ast.Clauses[0].Item1.Extent.Text -match $scriptReplacements[0].v3IfConditionMatch
                    }, $true)

                if (-not $ifStatement)
                {
                    throw "The expected if statement was not found in the input script."
                }

                foreach ($scriptReplacement in $scriptReplacements)
                {
                    # Find the if clause to process from the v3 deployment script
                    $ifClause = $ifStatement.Clauses | Where-Object { $_.Item1.Extent.Text -match $scriptReplacement.v3IfConditionMatch }

                    if ($ifClause)
                    {
                        Write-Verbose -Message "Found statement: if ($($ifClause.Item1.Extent.Text))"

                        # Re-read and parse the v4 template script after each replacement so that the offsets will still be valid
                        $tempScriptContent = Get-Content -Path $outputScriptPath -Raw
                        $tempScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($tempScriptContent, [ref]$null, [ref]$null)

                        # Find the function definition in the v4 template script to fill in
                        $functionAst = $tempScriptAst.Find({
                                param ($ast)
                                $ast -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $ast.Name -eq $scriptReplacement.v4FunctionName
                            }, $true)

                        if ($functionAst)
                        {
                            Write-Verbose -Message "Updating function [$($scriptReplacement.v4FunctionName)]"

                            # Update the content of the v4 template script
                            $start = $functionAst.Body.Extent.StartOffset
                            $end = $functionAst.Body.Extent.EndOffset
                            $scriptContent = $tempScriptAst.Extent.Text
                            $newScriptContent = ($scriptContent.Substring(0, $start) + $ifClause.Item2.Extent.Text + $scriptContent.Substring($end)).Trim()

                            # Fix to make converted InstallPhase declarations from v3 match the syntax used in the v4 template
                            $newScriptContent = $newScriptContent -replace '\[String\]\$adtSession.InstallPhase = ''(Pre-|Post-)(?:Installation|Uninstallation|Repair)''', '$adtSession.InstallPhase = "$1$($adtSession.DeploymentType)"' -replace '\[String\]\$adtSession.InstallPhase = ''(?:Installation|Uninstallation|Repair)''', '$adtSession.InstallPhase = $adtSession.DeploymentType'

                            #Fix to convert MARK labels to match v4 format
                            $newScriptContent = $newScriptContent.Replace('##* MARK: PRE-INSTALLATION', '## MARK: Pre-Install').Replace('##* MARK: INSTALLATION', '## MARK: Install').Replace('##* MARK: POST-INSTALLATION', '## MARK: Post-Install').Replace('##* MARK: PRE-UNINSTALLATION', '## MARK: Pre-Uninstall').Replace('##* MARK: UNINSTALLATION', '## MARK: Uninstall').Replace('##* MARK: POST-UNINSTALLATION', '## MARK: Post-Uninstall').Replace('##* MARK: PRE-REPAIR', '## MARK: Pre-Repair').Replace('##* MARK: REPAIR', '## MARK: Repair').Replace('##* MARK: POST-REPAIR', '## MARK: Post-Repair')

                            Set-Content -Path $outputScriptPath -Value $newScriptContent -Encoding UTF8
                        }
                    }
                    else
                    {
                        Write-Warning -Message "The if statement for [$($scriptReplacement.v4FunctionName)] was not found in the input script."
                    }
                }

                # Re-read and parse the script one more time
                $tempScriptContent = Get-Content -Path $outputScriptPath -Raw
                $tempScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($tempScriptContent, [ref]$null, [ref]$null)

                # Find the hashtable in the v4 template script that holds the adtSession splat
                $hashtableAst = $tempScriptAst.Find({
                        param ($ast)
                        $ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and ($ast.Left | Get-Member -Name VariablePath) -and $ast.Left.VariablePath.UserPath -eq 'adtSession'
                    }, $true)

                if ($hashtableAst)
                {
                    Write-Verbose -Message 'Processing $adtSession hashtable'

                    # Get the text form of the hashtable definition
                    $hashtableContent = $hashtableAst.Right.Extent.Text

                    # Copy each variable value from the input script to the hashtable
                    foreach ($variableReplacement in $variableReplacements)
                    {
                        $assignmentAst = $inputScriptAst.Find({
                                param ($ast)
                                $ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and $ast.Left.Extent.Text -match "^(\[[^\]]+\])?\`$(adtSession\.)?$variableReplacement$"
                            }, $true)

                        if ($assignmentAst)
                        {
                            Write-Verbose -Message "Updating variable [$variableReplacement]"
                            $variableValue = $assignmentAst.Right.Extent.Text
                            $hashtableContent = $hashtableContent -replace "(?m)(^\s*$variableReplacement\s*=)\s*'[^']*'", "`$1 $variableValue"
                        }
                    }

                    # Update AppProcessesToClose if Show-ADTInstallationWelcome -CloseProcesses is present in the converted script
                    $saiwAst = $tempScriptAst.Find({
                            param ($ast)
                            $ast -is [System.Management.Automation.Language.CommandAst] -and $ast.GetCommandName() -eq 'Show-ADTInstallationWelcome'
                        }, $true)
                    if ($saiwAst) {
                        $boundParameters = ($spBinder::BindCommand($saiwAst, $true)).BoundParameters
                        $closeProcesses = $null
                        if ($boundParameters.TryGetValue('CloseProcesses', [ref]$closeProcesses)) {
                            if ($closeProcesses.Value | Get-Member -Name VariablePath)
                            {
                                $assignmentAst = $inputScriptAst.Find({
                                        param ($ast)
                                        $ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and ($ast.Left | Get-Member -Name VariablePath) -and $ast.Left.VariablePath.UserPath -eq $closeProcesses.Value.VariablePath.UserPath
                                    }, $true)
                                $appProcessesToClose = if ($assignmentAst) { $assignmentAst.Right.Extent.Text } else { '@()' }
                            }
                            else
                            {
                                $appProcessesToClose = $closeProcesses.Value.Extent.Text
                            }
                            Write-Verbose -Message "Updating variable [AppProcessesToClose]"
                            $hashtableContent = $hashtableContent -replace "(?m)(^\s*AppProcessesToClose\s*=)\s*@\(\)", "`$1 $appProcessesToClose"
                        }
                    }

                    Write-Verbose -Message 'Updating variable [AppScriptDate]'
                    $hashtableContent = $hashtableContent -replace "(?m)(^\s*AppScriptDate\s*=)\s*'[^']+'", "`$1 '$(Get-Date -Format "yyyy-MM-dd")'"

                    # Update the content of the v4 template script
                    $start = $hashtableAst.Right.Extent.StartOffset
                    $end = $hashtableAst.Right.Extent.EndOffset
                    $scriptContent = $tempScriptAst.Extent.Text
                    $newScriptContent = ($scriptContent.Substring(0, $start) + $hashtableContent + $scriptContent.Substring($end)).Trim()
                    Set-Content -Path $outputScriptPath -Value $newScriptContent -Encoding UTF8
                }
                else
                {
                    Write-Warning -Message 'Could not find [$adtSession] hashtable'
                }

                Write-Verbose -Message "Removing temp script [$inputScriptPath]"
                Remove-Item -LiteralPath $inputScriptPath -Force

                $DestinationParent = Split-Path -Path $Destination -Parent
                if (!(Test-Path -LiteralPath $DestinationParent -PathType Container))
                {
                    Write-Verbose -Message "Creating parent folder [$DestinationParent]"
                    New-Item -Path $DestinationParent -ItemType Directory -Force | Out-Null
                }

                if ($Path -like '*.ps1')
                {
                    Write-Verbose -Message "Moving file [$outputScriptPath] to [$Destination]"
                    Move-Item -LiteralPath $outputScriptPath -Destination $Destination -Force -PassThru:$PassThru

                    # Display the newly created file in Windows Explorer (/select highlights the file in the folder).
                    if ($Show)
                    {
                        Write-Verbose -Message "Selecting [$Destination] in Windows Explorer"
                        & ([System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Windows), 'explorer.exe')) /select, $Destination
                    }
                }
                else
                {
                    # If processing a folder, also copy the Files and SupportFiles subfolders
                    foreach ($subFolder in 'Files', 'SupportFiles')
                    {
                        $subFolderPath = [System.IO.Path]::Combine($Path, $subFolder)
                        if ([System.IO.Directory]::Exists($subFolderPath))
                        {
                            Write-Verbose -Message "Copying $subFolder content"
                            Copy-Item -LiteralPath $subFolderPath -Destination $tempFolderPath -Recurse -Force
                        }
                    }

                    # Remove the Destination if it already exists (we should have already exited by this point if folder exists and Force not specified)
                    if (Test-Path -LiteralPath $Destination)
                    {
                        Write-Verbose -Message "Removing existing destination folder [$Destination]"
                        Remove-Item -LiteralPath $Destination -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    # Sometimes previous actions were leaving a lock on the temp folder, so set up a retry loop
                    for ($i = 0; $i -lt 5; $i++)
                    {
                        try
                        {
                            Write-Verbose -Message "Moving folder [$tempFolderPath] to [$Destination]"
                            [System.Threading.Thread]::Sleep(500)
                            Move-Item -Path $tempFolderPath -Destination $Destination -Force -PassThru:$PassThru
                            Write-Information -MessageData "Conversion successful: $Destination"
                            break
                        }
                        catch
                        {
                            if ($i -eq 4)
                            {
                                throw
                            }
                            Write-Verbose -Message "Failed to move folder. Trying again in 500ms."
                        }
                    }

                    # Display the newly created folder in Windows Explorer.
                    if ($Show)
                    {
                        Write-Verbose -Message "Opening [$Destination] in Windows Explorer"
                        & ([System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Windows), 'explorer.exe')) $Destination
                    }

                }
            }
            catch
            {
                # Re-writing the ErrorRecord with Write-Error ensures the correct PositionMessage is used.
                Write-Error -ErrorRecord $_
            }
            finally
            {
                if ((Get-Variable -Name 'tempFolderPath' -ErrorAction Ignore) -and (Test-Path -LiteralPath $tempFolderPath))
                {
                    Write-Verbose -Message "Removing temp folder [$tempFolderPath]"
                    Remove-Item -Path $tempFolderPath -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
        }
        catch
        {
            # Process the caught error, log it and throw depending on the specified ErrorAction.
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        # Finalize function.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}
