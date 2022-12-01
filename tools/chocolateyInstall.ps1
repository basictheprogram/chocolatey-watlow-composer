$ErrorActionPreference = 'Stop';

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)
$WorkSpace = Join-Path $env:TEMP $env:ChocolateyPackageName
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. $toolsDir\helpers.ps1

$composer = Join-Path $toolsDir 'Watlow_COMPOSER.cer'

$cert = Get-ChildItem Cert:\CurrentUser\TrustedPublisher -Recurse | Where-Object { $_.Thumbprint -eq 'a13918d0df7dc593b7967b7bc28034fb2e66bf18' }
if (!$cert) {
    Start-ChocolateyProcessAsAdmin "certutil -addstore 'TrustedPublisher' '$composer'"
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    silentArgs     = '/exenoui /exenoupdates /passive /norestart'
    softwareName   = 'Watlow COMPOSER'
    validExitCodes = @(0, 3010, 1641)

    url            = $data.url
    checksum       = $data.checksum
    checksumType   = $data.checksumType
}

Install-ChocolateyPackage @packageArgs
