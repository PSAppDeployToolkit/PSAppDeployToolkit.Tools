# ![AppDeployToolkitLogo](https://github.com/user-attachments/assets/7766bcb3-fa87-496e-9b19-7a8e194dcd97)

## Enterprise App Packaging, Simplified.

PSAppDeployToolkit.Tools is a companion module for [PSAppDeployToolkit](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit) that provides tools and functions useful during the application packaging process. Having this separate allows for a separate release schedule and also reduces the file size of the module that is required to be delivered to endpoints to handle software deployments.

### Features

- **Test-ADTCompatibility** - Test your PSAppDeployToolkit v3 scripts to get a full report on which functions and variables have changed in v4.
- **Convert-ADTDeployment** - Convert a PSAppDeployToolkit v3 script or an entire package folder to v4 standards.

## Getting Started

Install the module from the PowerShell Gallery:

```powershell
Install-Module PSAppDeployToolkit.Tools -Scope CurrentUser
```

Example command usage:

```powershell
Test-ADTCompatibility -FilePath .\Deploy-Application.ps1 -Format Grid
```

This example analyzes Deploy-Application.ps1 and outputs the results as a grid view.

```powershell
Convert-ADTDeployment -Path .\Deploy-Application.ps1
```

This example converts Deploy-Application.ps1 into Invoke-AppDeployToolkit.ps1 in the same folder.

```powershell
Convert-ADTDeployment -Path .\PackageFolder
```

This example converts PackageFolder into PackageFolder_Converted in the same folder.

### PSAppDeployToolkit Links

-> [Homepage](https://psappdeploytoolkit.com)
-> [Documentation](https://psappdeploytoolkit.com/docs)
-> [Function & Variable References](https://psappdeploytoolkit.com/docs/reference)
-> [Download Latest Release](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/releases)
-> [News](https://psappdeploytoolkit.com/blog)

### Community Links

-> [Discourse Forum](https://discourse.psappdeploytoolkit.com/)
-> [Discord Chat](https://discord.com/channels/618712310185197588/627204361545842688)
-> [Reddit](https://reddit.com/r/psadt)

## License

The PowerShell App Deployment Tool is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.
