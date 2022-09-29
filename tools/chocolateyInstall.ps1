﻿$ErrorActionPreference = 'Stop';

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)
$WorkSpace = Join-Path $env:TEMP $env:ChocolateyPackageName
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$composer = Join-Path $toolsDir 'Watlow_COMPOSER.cer'
Import-Certificate -FilePath $composer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    silentArgs     = '/S'
    softwareName   = 'Watlow COMPOSER'
    validExitCodes = @(0, 3010, 1641)

    url            = $data.url
    checksum       = $data.checksum
    checksumType   = $data.checksumType
}

Install-ChocolateyPackage @packageArgs
