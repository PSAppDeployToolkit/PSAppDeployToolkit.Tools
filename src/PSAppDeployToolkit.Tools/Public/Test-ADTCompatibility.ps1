#-----------------------------------------------------------------------------
#
# MARK: Test-ADTCompatibility
#
#-----------------------------------------------------------------------------

function Test-ADTCompatibility
{
    <#
    .SYNOPSIS
        Tests a PSAppDeployToolkit deployment scripts such as Deploy-Application.ps1 or Invoke-AppDeployToolkit.ps1 for any deprecated v3.x command or variable usage.

    .DESCRIPTION
        The Test-ADTCompatibility function run custom PSScriptAnalyzer rules against the input file and output any detected issues. The results can be output in a variety of formats.

    .PARAMETER FilePath
        Path to the .ps1 file to analyze.

	.PARAMETER Format
		Specifies the output format. The acceptable values for this parameter are: Raw, Table, Grid. The default value is Raw, which outputs the raw DiagnosticRecord objects from PSScriptAnalyzer. Table outputs just the line numbers and messages as a table. Grid outputs the line numbers and messages in a graphical window.

    .INPUTS
        System.String

        You can pipe script files to this function.

    .OUTPUTS
        Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord

        Returns the standard output from Invoke-ScriptAnalyzer.

    .EXAMPLE
        Test-ADTCompatibility -FilePath .\Deploy-Application.ps1

        This example analyzes Deploy-Application.ps1 and outputs the results.

	.EXAMPLE
        Test-ADTCompatibility -FilePath .\Deploy-Application.ps1 -Format Table

        This example analyzes Deploy-Application.ps1 and outputs the results as a table.

	.EXAMPLE
        Test-ADTCompatibility -FilePath .\Deploy-Application.ps1 -Format Grid

        This example analyzes Deploy-Application.ps1 and outputs the results as a grid view.

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
                if (![System.IO.File]::Exists($_))
                {
                    $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName FilePath -ProvidedValue $_ -ExceptionMessage 'The specified file does not exist.'))
                }
                return ![System.String]::IsNullOrWhiteSpace($_)
            })]
        [System.String]$FilePath,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Raw', 'Table', 'Grid')]
        [System.String]$Format = 'Raw'
    )

    begin
    {
        # Initialize function.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $customRulePath = [System.IO.Path]::Combine($MyInvocation.MyCommand.Module.ModuleBase, 'PSScriptAnalyzer\Measure-ADTCompatibility.psm1')
    }

    process
    {
        try
        {
            try
            {
                if ($FilePath -notmatch '(Deploy-Application\.ps1|Invoke-AppDeployToolkit\.ps1)$')
                {
                    Write-Warning -Message "This function is designed to test PSAppDeployToolkit deployment scripts such as Deploy-Application.ps1 or Invoke-AppDeployToolkit.ps1."
                }
                $results = Invoke-ScriptAnalyzer -Path $FilePath -CustomRulePath $customRulePath

                switch ($Format)
                {
                    'Table' { $results | Format-Table -AutoSize -Wrap -Property Line, Message }
                    'Grid' { $results | Select-Object Line, Message | Out-GridView -Title "Test-ADTCompatibility: $FilePath" -OutputMode None }
                    'Raw' { $results }
                }
            }
            catch
            {
                # Re-writing the ErrorRecord with Write-Error ensures the correct PositionMessage is used.
                Write-Error -ErrorRecord $_
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
