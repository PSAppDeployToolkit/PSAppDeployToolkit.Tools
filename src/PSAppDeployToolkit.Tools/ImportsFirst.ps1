<#

.SYNOPSIS
PSAppDeployToolkit.Tools - companion module for PSAppDeployToolkit.

.DESCRIPTION
This module script contains functions to aid enterprise application packaging and the creation of PSAppDeployToolkit deployment scripts.

PSAppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2025 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham, Muhammad Mashwani, Mitch Richters, Dan Gough).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.LINK
https://psappdeploytoolkit.com

#>

#-----------------------------------------------------------------------------
#
# MARK: Module Initialization Code
#
#-----------------------------------------------------------------------------

# Define modules needed to build out CommandTable.
$RequiredModules = [System.Collections.ObjectModel.ReadOnlyCollection[Microsoft.PowerShell.Commands.ModuleSpecification]]$(
    @{ ModuleName = 'Microsoft.PowerShell.Management'; Guid = 'eefcb906-b326-4e99-9f54-8b4bb6ef3c6d'; ModuleVersion = '1.0' }
    @{ ModuleName = 'Microsoft.PowerShell.Utility'; Guid = '1da87e53-152b-403e-98dc-74d7b4d63d59'; ModuleVersion = '1.0' }
    @{ ModuleName = 'PSAppDeployToolkit'; Guid = '8c3c366b-8606-4576-9f2d-4051144f7ca2'; ModuleVersion = '4.1.0' }
    @{ ModuleName = 'PSScriptAnalyzer'; Guid = 'd6245802-193d-4068-a631-8863a4342a18'; ModuleVersion = '1.23.0' }
)

# Build out lookup table for all cmdlets used within module, starting with the core cmdlets.
$CommandTable = [ordered]@{}; $ExecutionContext.SessionState.InvokeCommand.GetCmdlets() | & { process { if ($_.PSSnapIn -and $_.PSSnapIn.Name.Equals('Microsoft.PowerShell.Core') -and $_.PSSnapIn.IsDefault) { $CommandTable.Add($_.Name, $_) } } }
(& $CommandTable.'Import-Module' -FullyQualifiedName $RequiredModules -Global -Force -PassThru -ErrorAction Stop).ExportedCommands.Values | & { process { $CommandTable.Add($_.Name, $_) } }

# Set required variables to ensure module functionality.
& $CommandTable.'New-Variable' -Name ErrorActionPreference -Value ([System.Management.Automation.ActionPreference]::Stop) -Option Constant -Force
& $CommandTable.'New-Variable' -Name InformationPreference -Value ([System.Management.Automation.ActionPreference]::Continue) -Option Constant -Force
& $CommandTable.'New-Variable' -Name ProgressPreference -Value ([System.Management.Automation.ActionPreference]::SilentlyContinue) -Option Constant -Force

# Ensure module operates under the strictest of conditions.
& $CommandTable.'Set-StrictMode' -Version 3

# Import this module's manifest via the language parser. This allows us to test with potential extra variables that are permitted in manifests.
# https://github.com/PowerShell/PowerShell/blob/7ca7aae1d13d19e38c7c26260758f474cb9bef7f/src/System.Management.Automation/engine/Modules/ModuleCmdletBase.cs#L509-L512
$Module = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\PSAppDeployToolkit.Tools.psd1", [ref]$null, [ref]$null).GetScriptBlock()
$Module.CheckRestrictedLanguage([System.String[]]$null, [System.String[]]('PSEdition'), $true); $Module = & $Module

# Store build information pertaining to this module's state.
& $CommandTable.'New-Variable' -Name Module -Option Constant -Force -Value ([ordered]@{
        Manifest = $Module
        Compiled = $MyInvocation.MyCommand.Name.Equals('PSAppDeployToolkit.Tools.psm1')
    }).AsReadOnly()

# Remove any previous functions that may have been defined.
if ($Module.Compiled)
{
    & $CommandTable.'New-Variable' -Name FunctionNames -Option Constant -Value ($MyInvocation.MyCommand.ScriptBlock.Ast.EndBlock.Statements | & { process { if ($_ -is [System.Management.Automation.Language.FunctionDefinitionAst]) { return $_.Name } } })
    & $CommandTable.'New-Variable' -Name FunctionPaths -Option Constant -Value ($FunctionNames -replace '^', 'Microsoft.PowerShell.Core\Function::')
    & $CommandTable.'Remove-Item' -LiteralPath $FunctionPaths -Force -ErrorAction Ignore
}
