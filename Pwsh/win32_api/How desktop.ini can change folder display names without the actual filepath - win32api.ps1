$mdDocs = @'

## About

This started trying to find out why a UI folder renamename was not updating in the filesystme
it had a desktop.ini that only contained

    [.ShellClassInfo]
    LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21816

## Usage

    [GetString]::LoadString("C:\Windows\system32\shell32.dll", 21816)
    https://learn.microsoft.com/en-us/windows/win32/intl/using-registry-string-redirection#create-a-language-neutral-resource
'@

Add-Type -CompilerOptions '-unsafe' -TypeDefinition '
using System;
using System.Runtime.InteropServices;

public static unsafe class GetString
{
    private const uint LOAD_LIBRARY_AS_DATAFILE = 0x00000002;

    private const uint LOAD_LIBRARY_AS_IMAGE_RESOURCE = 0x00000020;

    [DllImport("kernel32.dll")]
    private static extern nint LoadLibraryExW(char* lpLibFileName, nint hFile, uint dwFlags);

    [DllImport("kernel32.dll")]
    private static extern int FreeLibrary(nint hInstance);

    [DllImport("user32.dll")]
    private static extern int LoadStringW(nint hInstance, uint uID, char** lpBuffer, int cchBufferMax);

    public static string LoadString(string path, int id)
    {
        fixed (char* pPath = path)
        {
            nint hInstance = 0;
            try
            {
                hInstance = LoadLibraryExW(
                    pPath,
                    0,
                    LOAD_LIBRARY_AS_DATAFILE | LOAD_LIBRARY_AS_IMAGE_RESOURCE);

                char* value = null;
                int length = LoadStringW(hInstance, (uint)id, &value, 0);
                return new string(value, 0, length);
            }
            finally
            {
                FreeLibrary(hInstance);
            }
        }
    }
}'

# $mdDocs 

hr 2
'[GetString]::LoadString("C:\Windows\system32\shell32.dll", 21816)'

[GetString]::LoadString("C:\Windows\system32\shell32.dll", 21816)
| Label 'C:\Windows\system32\shell32.dll", 21816' -Separator ' = '


hr
<#
    https://learn.microsoft.com/en-us/windows/win32/intl/using-registry-string-redirection#create-a-language-neutral-resource
#>