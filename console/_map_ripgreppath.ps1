'Powershell\My_Github\Mini.Examples\Format\File-Listing\Readme.md:3' -replace ':\d+$', ''
filter _map_RipGrepPath { 
   $_ -replace ':\d+$', ''   
}

'Powershell\My_Github\Mini.Examples\Format\File-Listing\Readme.md:3'
| _map_RipGrepPath
| gi
