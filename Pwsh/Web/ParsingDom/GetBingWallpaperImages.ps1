Import-Module PSParseHTML

function GetWallpaperUrls { 
    <#
    .synopsis
        Searches a page for all links that point to the full wallpaper page
    .example
        GetWallpaperUrl -Url 'https://bing.gifposter.com/archive/202401.html'
    #>
    param( [string]$Url )
    $resp = Invoke-WebRequest $Url

    # find all <a> tags
    $fromTag = ConvertFrom-HtmlTag -Content $resp -Tag 'a' -ReturnObject 
             | Where-Object { $_.PathName -match '^/Wallpaper' }

    $fromTag | ForEach-Object {          
          'https://bing.gifposter.com{0}' -f $_.PathName          
    }   
} 

function GetWallpaperImage {
    <#
    .synopsis
        Searches a page for the full image, using an ID
    .example
        GetWallpaperImage -Url 'https://bing.gifposter.com/wallpaper-2753-SleepingFox.html'
    .example
      $url_list | ForEach-Object { 
          GetWallpaperImage -Url $_
      }
    #>
    param( [string]$Url )
    
    [string]$IdName = '#bing_wallpaper'
    $response = Invoke-WebRequest $Url
    $doc = ConvertFrom-HTML -Content $response -Engine AngleSharp       
    $found = $doc.QuerySelector( $IdName )        
    
    # then return the src from the element
    # <img src='...' >            
    $found.Attributes['src'].TextContent           
}

