$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$functions = Join-Path -Path $moduleRoot -ChildPath 'Functions'

. (Resolve-Path "$functions\ConvertFrom-JsonWithArgs.ps1")
Export-ModuleMember -Function ConvertFrom-JsonWithArgs