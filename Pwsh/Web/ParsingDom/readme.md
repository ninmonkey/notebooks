- [GetBingWallpaperImages.ps1](./GetBingWallpaperImages.ps1)

## How to use

```ps1
> GetWallpaperUrl 'https://bing.gifposter.com/archive/202401.html'

> GetWallpaperImage 'https://bing.gifposter.com/wallpaper-2753-SleepingFox.html'
```
Chain them
```ps1
$url_list = GetWallpaperUrls -Url 'https://bing.gifposter.com/archive/202401.html'
$url_list | ForEach-Object { 
    GetWallpaperImage -Url $_
}
```
