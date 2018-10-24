# Using Embeds With All Additions

Check out the [examples](https://github.com/gngrninja/PSDsHook/tree/master/examples) folder for actual scripted examples!

To use embeds with this module, you'll first need to have a [using statement](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_using?view=powershell-6) to access the classes within it.

Example of using statement:
```powershell
using module PSDsHook
```

If the module is not installed into a folder within one of these directories:
```powershell
($env:PSModulePath -split "$([IO.Path]::PathSeparator)")
```

You'll need to use the following statement and point it to your local copy of the module's built .psm1 file.
```powershell
using module 'C:\users\thegn\repos\PsDsHook\out\PSDsHook\0.0.1\PSDsHook.psm1'
```

This is a variable that points to the image we'll use throughout this example
```powershell
$thumbUrl = 'https://static1.squarespace.com/static/5644323de4b07810c0b6db7b/t/5aa44874e4966bde3633b69c/1520715914043/webhook_resized.png'
```

Create embed builder object via the [DiscordEmbed] class. 
You can customize the title and description.
```powershell
$embedBuilder = [DiscordEmbed]::New(
                    'title',
                    'description'
                )
```

Create/add fields to the embed. The last value ($true) is if you want it to be in-line or not.
Fields allow you to organize things neatly within the embed.
```powershell
$embedBuilder.AddField(
    [DiscordField]::New(
        'field name', 
        'field value/contents', 
        $true
    )
)

$embedBuilder.AddField(
    [DiscordField]::New(
        'field name2',
        'field value2/contents2', 
        $true
    )
)
```

Add our thumbnail to the embed:
```powershell
$embedBuilder.AddThumbnail(
    [DiscordThumbnail]::New(
        $thumbUrl
    )
)
```

Add a color:
```powershell
$embedBuilder.WithColor(
    [DiscordColor]::New(
            'blue'
    )
)
```

Add an author:
```powershell
$embedBuilder.AddAuthor(
    [DiscordAuthor]::New(
        'Author',
        $thumbUrl
    )
)
```

Add a footer:
```powershell
$embedBuilder.AddFooter(
    [DiscordFooter]::New(
        'footer',
        $thumbUrl
    )
)
```

Add an image:
```powershell
$embedBuilder.AddImage(
    [DiscordImage]::New(
        $thumbUrl
    )
)
```

Finally, call the function that will send the embed object (or array of embed objects) to the webhook url:
```powershell
Invoke-PSDsHook -EmbedObject $embedBuilder -Verbose
```

![example](https://raw.githubusercontent.com/gngrninja/PSDsHook/master/media/loadedEmbed.PNG)