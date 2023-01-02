# Changelog
## 2023-01-01 - Version 1.13.2
* Fix incorrect pluralisation of Get-HaloCustomField.
* Changes to pipeline and release process.
## 2023-01-01 - Version 1.13.1
* Added IncludeTenants Switch to Get-HaloAzureADConnection to fix Contact sync script.
## 2022-11-18 - Version 1.13.0
* Adds Recover-HaloTicket and -Deleted parameter for Get-HaloTicket.
* Fix 429 (API rate limiting) response handling.
* Refactor of 429 error handling.
* Increase batch wait to 30 seconds.
* Adds Remove-HaloItem.
## 2022-09-16 - Version 1.11.1
* Fix for PostedOnly and NonPostedOnly parameters on Get-HaloInvoice.
## 2022-07-02 - Version 1.10.1
* Fix incorrect bugfix reversion affecting batch cmdlets.
## 2022-07-01 - Version 1.10.0
* Internal contract change, Invoke-HaloBatchProcessor now uses BatchInput instead of Input. Bugfixes for batch processing.
