using module /Users/ninja/Documents/repos/discordWebHook/psdshook.psm1
[DiscordColor]::New('blue')

#Create array of hook properties
$possibleHookProperties = [PSCustomObject]@{

    avatar_url = $avatarUrl
    username   = $userName

}

$avatarUrl   = 'https://static1.squarespace.com/static/5644323de4b07810c0b6db7b/t/5939e82c3e00beb37d5bc3af/1496967218880/?format=1000w'
$contentType = 'application/json'

[System.Collections.ArrayList]$embedArray = @()

$embedColor  = [DiscordColor]::New($Color)

$embedArray.Add($(Get-EmbedFormat -Title $Title -Content $Content -ColorValue $embedColor.DecimalColor)) | Out-Null

$hookObject = [PSCustomObject]@{

    embeds = $embedArray

}