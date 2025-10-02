# ![PSAppDeployToolkit.Tools](https://github.com/user-attachments/assets/a275b3f9-6a45-42f0-a377-a57036d3f84d)

## 🚀 Enterprise App Packaging, Extended

PSAppDeployToolkit.Tools is a companion module for [PSAppDeployToolkit](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit) that provides tools and functions useful during the application packaging process. Having this separate allows for a separate release schedule and also reduces the file size of the module that is required to be delivered to endpoints to handle software deployments.

### ✨ Key Features

- **Test-ADTCompatibility** - Test your PSAppDeployToolkit v3 scripts to get a full report on which functions and variables have changed in v4.1.
- **Convert-ADTDeployment** - Convert a PSAppDeployToolkit v3 script or an entire package folder to v4.1 standards.

## 🚀 Getting Started

### Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- .NET Framework 4.7.2 or later

### Installing The Module

Install the module from the PowerShell Gallery:

```powershell
Install-Module PSAppDeployToolkit.Tools -Scope CurrentUser
```

Alternatively you can import a downloaded copy of the module - however with this approach, you will need to ensure its pre-requisite modules **PSAppDeployToolkit 4.1.5** and **PSScriptAnalyzer 1.24.0** are available:

```powershell
Import-Module "<Path To PSAppDeployToolkit.Tools.psd1>"
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

## 📄 License

This project is licensed under the [GNU Lesser General Public License](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/blob/main/COPYING.Lesser)

## Important Links

### PSAppDeployToolkit

- [Homepage](https://psappdeploytoolkit.com)
- [Latest News](https://psappdeploytoolkit.com/blog)
- [Documentation](https://psappdeploytoolkit.com/docs/introduction)
- [Function & Variable References](https://psappdeploytoolkit.com/docs/reference)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/PSAppDeployToolkit)
- [GitHub Releases](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/releases)

### Community

- [Discourse Forum](https://discourse.psappdeploytoolkit.com/)
- [Discord Chat](https://discord.com/channels/618712310185197588/627204361545842688)
- [Reddit](https://reddit.com/r/psadt)

### GitHub

- [Issues](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/issues)
- [Security Policy](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/security)
- [Contributor Guidelines](https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/blob/main/.github/CONTRIBUTING.md)
