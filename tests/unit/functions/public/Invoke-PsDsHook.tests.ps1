InModuleScope PsDsHook {

    describe 'Invoke-PsDsHook' {

        $dirSeparator = [IO.Path]::DirectorySeparatorChar

        mock 'Invoke-RestMethod' {

            $mockResult = [PSCustomObject]@{

                Uri     = $Uri
                Payload = $Body

            }

            return $mockResult
            
        }

        $configDir      = "$PSScriptRoot$($dirSeparator)..$($dirSeparator)..$($dirSeparator)..$($dirSeparator)artifacts$($dirSeparator)"
        $configFullPath = "$PSScriptRoot\..\..\..\artifacts\config.json"        
        $testHookUrl    = 'www.hook.com'
        $name           = 'config'
        
        it 'Should be able to create a configuration file' {
                                                
            Write-Host "$configFullPath"
            Invoke-PsDsHook -CreateConfig -ConfigName $name -WebhookUrl $testHookUrl            

        }

        it 'Should be able to receive an embed array' {

            [System.Collections.ArrayList]$embedArray = @()            
            $embedBuilder = [DiscordEmbed]::New('test title', 'test content')

            $embedArray.Add($embedBuilder) | Out-Null

            $result = Invoke-PsDsHook -EmbedObject $embedArray -ConfigName $name        
            
            Assert-MockCalled -CommandName 'Invoke-RestMethod'
            
            $payload = [PSCustomObject]@{

                embeds = $embedArray

            } | ConvertTo-Json -Depth 4

            $result.Uri     | Should Be $testHookUrl
            $result.Payload | Should Be $payload 

        }

        it 'Should be able to receive an embed (no array)' {
  
            $embedBuilder = [DiscordEmbed]::New('test title', 'test content')

            $embedArray = New-Object 'System.Collections.Generic.List[DiscordEmbed]'
            $embedArray.Add($embedBuilder) | Out-Null

            $result = Invoke-PsDsHook -EmbedObject $embedBuilder -ConfigName $name        
            
            Assert-MockCalled -CommandName 'Invoke-RestMethod'     

            $payload = [PSCustomObject]@{

                embeds = $embedArray

            } | ConvertTo-Json -Depth 4

            $result.Uri     | Should Be $testHookUrl
            $result.Payload | Should Be $payload 

        }

        it 'Should be able to receive a file path' {

            $filePath = Get-ChildItem "$PSScriptRoot$($dirSeparator)..$($dirSeparator)..$($dirSeparator)..$($dirSeparator)artifacts$($dirSeparator)test.file"            

            if ($PSVersionTable.PSVersion.Major -lt 6) {

                {$result = Invoke-PsDsHook -FilePath $filePath -ConfigName $name} | 
                            Should Throw "Support for sending files is not yet available in PowerShell 5.x"

            } else {

                $result   = Invoke-PsDsHook -FilePath $filePath -ConfigName $name
    
                $result.Uri     | Should Be $testHookUrl
                $result.Payload | Should Be 'System.Net.Http.StreamContent'

            }
        }

        it 'Should list configurations' {

            $list           = (Get-ChildItem -Path (Split-Path -Path $configFullPath) | Where-Object {$_.Extension -eq '.json'} | Select-Object -ExpandProperty Name)
            $listFromModule = Invoke-PsDsHook -ListConfigs

            $list | Should Be $listFromModule

        }

        if (Test-Path -Path $configFullPath) {

            Remove-Item -Path $configFullPath -Force
            
        }
    }
}