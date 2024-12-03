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
        Requires PSScriptAnalyzer module 1.23.0 or later. To install:

        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
        Install-Module -Name PSScriptAnalyzer -Scope AllUsers

        Tags: psadt
        Website: https://psappdeploytoolkit.com
        Copyright: (C) 2024 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham, Muhammad Mashwani, Mitch Richters, Dan Gough).
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
                elseif ([System.IO.File]::Exists($_) -and [System.IO.Path]::GetExtension($_) -ne '.ps1')
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'The specified file is not a PowerShell script.'))
                }
                elseif ([System.IO.Directory]::Exists($_) -and -not [System.IO.File]::Exists([System.IO.Path]::Combine($_, 'Deploy-Application.ps1')))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'Deploy-Application.ps1 not found in the specified path.'))
                }
                elseif ([System.IO.Directory]::Exists($_) -and -not [System.IO.Directory]::Exists([System.IO.Path]::Combine($_, 'AppDeployToolkit')))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'AppDeployToolkit folder not found in the specified path.'))
                }
                return ![System.String]::IsNullOrWhiteSpace($_)
            })]
        [System.String]$Path,

        [Parameter(Mandatory = $false)]
        [string]$Destination = (Split-Path -Path $Path -Parent),

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
        $templateScriptPath = [System.IO.Path]::Combine($MyInvocation.MyCommand.Module.ModuleBase, 'Frontend\v4\Invoke-AppDeployToolkit.ps1')
    }

    process
    {
        try
        {
            try
            {
                $tempFolderName = "Convert-ADTDeployment_$([System.IO.Path]::GetRandomFileName().Replace('.', ''))"
                $tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), $tempFolderName)

                if ([System.IO.File]::Exists($Path))
                {
                    Write-Verbose -Message "Input path is a file: $Path"

                    # Update destination path with a specific filename if current value does not end in .ps1
                    $Destination = if ($Destination -like '*.ps1') { $Destination } else { [System.IO.Path]::Combine($Destination, 'Invoke-AppDeployToolkit.ps1') }

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

                    if ($Path -notmatch '(Deploy-Application\.ps1|Invoke-AppDeployToolkit\.ps1)$')
                    {
                        Write-Warning -Message "This function is designed to convert PSAppDeployToolkit deployment scripts such as Deploy-Application.ps1 or Invoke-AppDeployToolkit.ps1."
                    }

                    # Create the temp folder
                    New-Item -Path $tempPath -ItemType Directory -Force | Out-Null
                    # Create a temp copy of the script to run ScriptAnalyzer fixes on - prefix filename with _ in case it's named Invoke-AppDeployToolkit.ps1
                    $inputScriptPath = [System.IO.Path]::Combine(([System.IO.Path]::GetDirectoryName($fullPath)), "_$([System.IO.Path]::GetFileName($fullPath))")
                    Copy-Item -LiteralPath $Path -Destination $inputScriptPath -Force -PassThru
                    # Copy over our template v4 script
                    $tempScriptPath = (Copy-Item -LiteralPath $templateScriptPath -Destination $tempPath -Force -PassThru).FullName
                }
                elseif ([System.IO.Directory]::Exists($Path))
                {
                    Write-Verbose -Message "Input path is a folder: $Path"

                    # Re-use the same folder name with _Converted suffix for the new folder
                    $folderName = "$(Split-Path -Path $Path -Leaf)_Converted"

                    # Update destination path to append this new folder name
                    $Destination = [System.IO.Path]::Combine($Destination, $folderName)

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

                    # Use New-ADTTemplate to generate our temp folder
                    New-ADTTemplate -Destination ([System.IO.Path]::GetTempPath()) -Name $tempFolderName

                    # Create a temp copy of Deploy-Application.ps1 to run ScriptAnalyzer fixes on
                    $inputScriptPath = (Copy-Item -LiteralPath ([System.IO.Path]::Combine($Path, 'Deploy-Application.ps1')) -Destination $tempPath -Force -PassThru).FullName

                    # Set the path of our v4 template script
                    $tempScriptPath = [System.IO.Path]::Combine($tempPath, 'Invoke-AppDeployToolkit.ps1')
                }

                # First run the fixes on the input script to update function names and variables
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
                        # Re-read and parse the v4 template script after each replacement so that the offsets will still be valid
                        $tempScriptContent = Get-Content -Path $tempScriptPath -Raw
                        $tempScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($tempScriptContent, [ref]$null, [ref]$null)

                        # Find the function definition in the v4 template script to fill in
                        $functionAst = $tempScriptAst.Find({
                                param ($ast)
                                $ast -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $ast.Name -eq $scriptReplacement.v4FunctionName
                            }, $true)

                        if ($functionAst)
                        {
                            # Update the content of the v4 template script
                            $start = $functionAst.Body.Extent.StartOffset
                            $end = $functionAst.Body.Extent.EndOffset
                            $scriptContent = $tempScriptAst.Extent.Text
                            $newScriptContent = ($scriptContent.Substring(0, $start) + $ifClause.Item2.Extent.Text + $scriptContent.Substring($end)).Trim()
                            Set-Content -Path $tempScriptPath -Value $newScriptContent -Encoding UTF8
                        }
                    }
                }

                # Re-read and parse the script one more time
                $tempScriptContent = Get-Content -Path $tempScriptPath -Raw
                $tempScriptAst = [System.Management.Automation.Language.Parser]::ParseInput($tempScriptContent, [ref]$null, [ref]$null)

                # Find the hashtable in the v4 template script that holds the adtSession splat
                $hashtableAst = $tempScriptAst.Find({
                        param ($ast)
                        $ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and $ast.Left.VariablePath.UserPath -eq 'adtSession'
                    }, $true)

                if ($hashtableAst)
                {
                    # Get the text form of the hashtable definition
                    $hashtableContent = $hashtableAst.Right.Extent.Text

                    # Update the appScriptDate value to the current date
                    $hashtableContent = $hashtableContent -replace "appScriptDate\s*=\s*'[^']+'", "appScriptDate = '$(Get-Date -Format "yyyy-MM-dd")'"

                    # Copy each variable value from the input script to the hashtable
                    foreach ($variableReplacement in $variableReplacements)
                    {
                        $assignmentAst = $inputScriptAst.Find({
                                param ($ast)
                                $ast -is [System.Management.Automation.Language.AssignmentStatementAst] -and $ast.Left.Extent.Text -match "^\[[^\]]+\]?\`$$variableReplacement$"
                            }, $true)

                        if ($assignmentAst)
                        {
                            $variableValue = $assignmentAst.Right.Extent.Text
                            $hashtableContent = $hashtableContent -replace "$variableReplacement\s*=\s*'[^']*'", "$variableReplacement = $variableValue"
                        }
                    }

                    # Update the content of the v4 template script
                    $start = $hashtableAst.Right.Extent.StartOffset
                    $end = $hashtableAst.Right.Extent.EndOffset
                    $scriptContent = $tempScriptAst.Extent.Text
                    $newScriptContent = ($scriptContent.Substring(0, $start) + $hashtableContent + $scriptContent.Substring($end)).Trim()
                    Set-Content -Path $tempScriptPath -Value $newScriptContent -Encoding UTF8
                }

                # Delete the temporary copy of the v3 script used for processing
                Remove-Item -LiteralPath $inputScriptPath -Force

                if ($Path -like '*.ps1')
                {
                    # Move the updated script to the destination
                    Move-Item -LiteralPath $tempScriptPath -Destination $Destination -Force -PassThru:$PassThru
                }
                else
                {
                    # If processing a folder, also copy the Files and SupportFiles subfolders
                    foreach ($subFolder in 'Files', 'SupportFiles')
                    {
                        $subFolderPath = [System.IO.Path]::Combine($Path, $subFolder)
                        if ([System.IO.Directory]::Exists($subFolderPath))
                        {
                            Copy-Item -LiteralPath $subFolderPath -Destination $tempPath -Recurse -Force
                        }
                    }

                    # Remove the Destination if it already exists (Force checks were done earlier)
                    if (Test-Path -LiteralPath $Destination)
                    {
                        Remove-Item -LiteralPath $Destination -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    # Sometimes previous actions were leaving a lock on the temp folder, so set up a retry loop
                    for ($i = 0; $i -lt 5; $i++)
                    {
                        try
                        {
                            Move-Item -Path $tempPath -Destination $Destination -Force -PassThru:$PassThru
                            Write-Information -MessageData "Conversion successful: $Destination"
                            break
                        }
                        catch
                        {
                            Write-Verbose -Message "Failed to move [$tempPath] to [$Destination]. Trying again in 500ms."
                            [System.Threading.Thread]::Sleep(500)
                            if ($i -eq 4)
                            {
                                throw
                            }
                        }
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
                if (Test-Path -LiteralPath $tempPath)
                {
                    Write-Verbose -Message "Removing temp path [$tempPath]"
                    Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
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
