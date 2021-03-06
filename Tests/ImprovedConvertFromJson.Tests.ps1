$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $here
$moduleRoot = "$projectRoot\ImprovedConvertFromJson"
$manifestFile = "$moduleRoot\ImprovedConvertFromJson.psd1"
$appveyorFile = "$projectRoot\appveyor.yml"
$functions = "$moduleRoot\functions"

Describe "ImprovedConvertFromJson" {
    Context "All required tests are present" {
        It "Includes a test for each PowerShell function in the module" {
            Get-ChildItem -Path $functions -Filter "*.ps1" -Recurse | Where-Object -FilterScript {$_.Name -notlike '*.Tests.ps1'} | % {
                $_.FullName -replace '.ps1','.Tests.ps1' | Should Exist
            }
        }
    }

    Context "Manifest and AppVeyor" {

        $script:manifest = $null
        It "Includes a valid manifest file" {
            {
                $script:manifest = Test-ModuleManifest -Path $manifestFile -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }

        It "Manifest file includes the correct name" {
            $script:manifest.Name | Should Be ImprovedConvertFromJson
        }

        It "Manifest file includes the correct guid" {
            $script:manifest.Guid | Should Be 'bd4390dc-a8ad-4bce-8d69-f53ccf8e4163'
        }

        It "Manifest file includes a valid version" {
            $script:manifest.Version -as [Version] | Should Not BeNullOrEmpty
        }

        It "Includes an appveyor.yml file" {
            $appveyorFile | Should Exist
        }

        It "Appveyor.yml file includes the module version" {
            foreach ($line in (Get-Content $appveyorFile))
            {
                if ($line -match '^\D*(?<Version>(\d+\.){1,3}\d+).\{build\}')
                {
                    $script:appveyorVersion = $matches.Version
                    break
                }
            }
            $script:appveyorVersion               | Should Not BeNullOrEmpty
            $script:appveyorVersion -as [Version] | Should Not BeNullOrEmpty
        }

        It "Appveyor version matches manifest version" {
            $script:appveyorVersion -as [Version] | Should Be ( $script:manifest.Version -as [Version] )
        }
    }

    Context "Style checking" {

        $files = @(
            Get-ChildItem $here -Include *.ps1,*.psm1
            Get-ChildItem $functions -Include *.ps1,*.psm1 -Recurse
        )

        It 'Source files contain no trailing whitespace' {
            $badLines = @(
                foreach ($file in $files)
                {
                    $lines = [System.IO.File]::ReadAllLines($file.FullName)
                    $lineCount = $lines.Count

                    for ($i = 0; $i -lt $lineCount; $i++)
                    {
                        if ($lines[$i] -match '\s+$')
                        {
                            'File: {0}, Line: {1}' -f $file.FullName, ($i + 1)
                        }
                    }
                }
            )

            if ($badLines.Count -gt 0)
            {
                throw "The following $($badLines.Count) lines contain trailing whitespace: `r`n`r`n$($badLines -join "`r`n")"
            }
        }

        It 'Source files all end with a newline' {
            $badFiles = @(
                foreach ($file in $files)
                {
                    $string = [System.IO.File]::ReadAllText($file.FullName)
                    if ($string.Length -gt 0 -and $string[-1] -ne "`n")
                    {
                        $file.FullName
                    }
                }
            )

            if ($badFiles.Count -gt 0)
            {
                throw "The following files do not end with a newline: `r`n`r`n$($badFiles -join "`r`n")"
            }
        }
    }
}


