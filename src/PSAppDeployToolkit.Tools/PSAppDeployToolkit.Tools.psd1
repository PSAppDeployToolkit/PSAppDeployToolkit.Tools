#
# Module manifest for module 'PSAppDeployToolkit.Tools'
#
# Last modified: 2025-10-02
#

@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PSAppDeployToolkit.Tools.psm1'

    # Version number of this module.
    ModuleVersion = '0.3.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = 'b20417ce-57d3-40c2-923f-71dad3b7edd9'

    # Author of this module
    Author = 'PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham, Muhammad Mashwani, Mitch Richters, Dan Gough)'

    # Company or vendor of this module
    CompanyName = 'PSAppDeployToolkit Team'

    # Copyright statement for this module
    Copyright = 'Copyright © 2025 PSAppDeployToolkit Team. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Enterprise App Packaging, Extended.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1.14393.0'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion = '5.1.14393.0'

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = '4.7.2.0'

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion = '4.0.30319.42000'

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        @{ModuleName = 'PSAppDeployToolkit'; GUID = '8c3c366b-8606-4576-9f2d-4051144f7ca2'; ModuleVersion = '4.1.5'; }
        @{ModuleName = 'PSScriptAnalyzer'; GUID = 'd6245802-193d-4068-a631-8863a4342a18'; ModuleVersion = '1.24.0'; }
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Convert-ADTDeployment'
        'Test-ADTCompatibility'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    # VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tag to indicate pre-release status
            #Prerelease = ''

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'psappdeploytoolkit', 'adt', 'psadt', 'appdeployment', 'appdeploytoolkit', 'appdeploy', 'deployment', 'toolkit'

            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/PSAppDeployToolkit/PSAppDeployToolkit.Tools/refs/heads/main/COPYING.Lesser'

            # A URL to the main website for this project.
            ProjectUri = 'https://psappdeploytoolkit.com'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/PSAppDeployToolkit/PSAppDeployToolkit/refs/heads/main/src/PSAppDeployToolkit/Assets/AppIcon.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/PSAppDeployToolkit/PSAppDeployToolkit.Tools/releases'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://psappdeploytoolkit.com/docs'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
