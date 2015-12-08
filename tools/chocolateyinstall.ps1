# get the powershell scripts to install
$name   = 'ps-nvmw'
$url    = 'https://raw.githubusercontent.com/aaronpowell/ps-nvmw/master/NodeVersionManager.psm1'
$target = Join-Path $HOME 'Documents\WindowsPowerShell\Modules\ps-nvmw\NodeVersionManager.psm1'

Get-ChocolateyWebFile $name $target $url

# modify the users profile to load the version manager
function Insert-Script([ref]$originalScript, $script) {
    if(!($originalScript.Value -Contains $script)) { $originalScript.Value += $script }
}

try {
    if(Test-Path $PROFILE) {
        $oldProfile = @(Get-Content $PROFILE)
        $newProfile = @()
    }

    $newProfile = @(Get-Content $PROFILE)
    Insert-Script ([REF]$newProfile) "Import-Module $target"
    Set-Content -path $profile -value $newProfile -Force
} catch {
  try {
    if($oldProfile){ Set-Content -path $PROFILE -value $oldProfile -Force }
  }
  catch {}
  throw
}

