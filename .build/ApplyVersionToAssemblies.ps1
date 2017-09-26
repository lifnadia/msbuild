##-----------------------------------------------------------------------
## <copyright file="ApplyVersionToAssemblies.ps1">(c) http://TfsBuildExtensions.codeplex.com/. This source is subject to the Microsoft Permissive License. See http://www.microsoft.com/resources/sharedsource/licensingbasics/sharedsourcelicenses.mspx. All other rights reserved.</copyright>
##-----------------------------------------------------------------------
# Look for a 0.0.0.0 pattern in the build number. 
# If found use it to version the assemblies.
#
# For example, if the 'Build number format' build process parameter 
# $(BuildDefinitionName)_$(Year:yyyy).$(Month).$(DayOfMonth)$(Rev:.r)
# then your build numbers come out like this:
# "Build HelloWorld_2013.07.19.1"
# This script would then apply version 2013.07.19.1 to your assemblies.
	
# Enable -Verbose option
[CmdletBinding()]
	
# Disable parameter
# Convenience option so you can debug this script or disable it in 
# your build definition without having to remove it from
# the 'Post-build script path' build process parameter.
param([switch]$Disable)
if ($PSBoundParameters.ContainsKey('Disable'))
{
	Write-Verbose "Script disabled; no actions will be taken on the files."
}

 Write-Host Running PowerShell version $PSVersionTable.PSVersion.ToString()	

# Regular expression pattern to find the version in the build number 
# and then apply it to the assemblies
$VersionRegex = "\d+\.\d+\.\d+\.\d+"
	
# If this script is not running on a build server, remind user to 
# set environment variables so that this script can be debugged
if($Env:TF_BUILD_SOURCESDIRECTORY)
{
    Write-Output "Loading TFS 2013 Env Vars"
    $SourceDir = $Env:TF_BUILD_SOURCESDIRECTORY
    $BinDir = $Env:TF_BUILD_BINARIESDIRECTORY
    $BuildNumber = $Env:TF_BUILD_BUILDNUMBER
    $BuildName = $Env:TF_BUILD_BUILDDEFINITIONNAME
}
elseif($Env:BUILD_SOURCESDIRECTORY)
{
    Write-Output "Loading TFS 2015 Env Vars"
    $SourceDir = $Env:BUILD_SOURCESDIRECTORY
    $BinDir = $Env:BUILD_BINARIESDIRECTORY
    $BuildNumber = $Env:BUILD_BUILDNUMBER
    $BuildName = $Env:BUILD_DEFINITIONNAME
}

Write-Verbose "TF_BUILD_BUILDNUMBER: $BuildNumber"
	
# Get and validate the version data
$VersionData = [regex]::matches($BuildNumber,$VersionRegex)
switch($VersionData.Count)
{
   0		
	  { 
		 Write-Error "Could not find version number data in TF_BUILD_BUILDNUMBER."
		 exit 1
	  }
   1 {}
   default 
	  { 
		 Write-Warning "Found more than instance of version data in TF_BUILD_BUILDNUMBER." 
		 Write-Warning "Will assume first instance is version."
	  }
}
$NewVersion = $VersionData[0]
Write-Verbose "Version: $NewVersion"
	
# Remove read-only from the sources
Write-Output "$(Get-Date -format 'u') Removing read-only from '$SourceDir'"
attrib -r $SourceDir\*.* /s

Write-Output "$(Get-Date -format 'u') Applying version $NewVersion to assembly files."

# Apply the version to the assembly property files
$files = gci $SourceDir -recurse -include "*Properties*","My Project" | 
	?{ $_.PSIsContainer } | 
	foreach { gci -Path $_.FullName -Recurse -include AssemblyInfo.* }
if($files)
{
	Write-Verbose "Will apply $NewVersion to $($files.count) files."
	
	foreach ($file in $files) {
			
		if(-not $Disable)
		{
			$filecontent = Get-Content($file)
			$filecontent -replace $VersionRegex, $NewVersion | Out-File $file
			Write-Verbose "$file - version applied"
		}
	}
}
else
{
	Write-Warning "Found no files."
}
