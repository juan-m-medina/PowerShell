Set-StrictMode -Version Latest

<# 
 .Synopsis
  Builds the solution at the current folder with configuration and platform values.

 .Description
  Builds the solution at the current folder with configuration and platform values.
  Default values are "Debug" for Configuration and "Any Cpu" for platform.

 . Parameter configuration
 . 

 .Example
   # Build with defaults
   Build

 .Example
   # Build with specific values
   Build -configuration "Release" -platform "x86"
#>
function Build
{
  param
  (
    [string] $Configuration = "Debug",
    [string] $Platform = "Any Cpu",
    [string] $Solution = "",
    [string] $LogFileName = "c:\logs\msbuild\msbuild.log",
    [string] $FileLoggerParameters = "LogFile=$LogFileName",
    [string] $ConsoleLoggerParameters = "ErrorsOnly;Verbosity=minimal",
    [string] $Target = "Clean;Build"
  )

  Write-Host "Building $_" -foreground "green"; `
  & 'C:\Program Files (x86)\MSBuild\12.0\Bin\amd64\MSBuild.exe' `
  /maxCpuCount `
  /nologo `
  /target:$Target `
  /p:Configuration=$Configuration `
  /p:Platform=$Platform $Solution `
  /fileLogger `
  /fileLoggerParameters:$FileLoggerParameters `
  /consoleLoggerParameters:$ConsoleLoggerParameters `
}

function Recurse-Build
{
  param
  (
    [string] $Configuration = "Debug",
    [string] $Platform = "Any Cpu"
  )

  try
  {
    Get-ChildItem -path . -recurse -include *.sln | `
       ForEach-Object { `
         Build -configuration $Configuration -platform $Platform -solution "$_" `
      }
  }
  catch 
  {
    Write-Output "There was a problem with the Recurse Build, check logs"
  } 
}


# Exports
Export-ModuleMember -function Build
Export-ModuleMember -function Recurse-Build
 
