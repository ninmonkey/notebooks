$hostname = hostname
$Date      = $args[0]
$Threshold = $args[1]
$Counter   = $args[2]



$Meta = @{
    Hostname = $Hostname
    Date = $Date
    Threshold = 34
    # Counter
}

$Value = "[{0}] {1} {2} | {3}" -F $Date, 'High CPU', $Threshold, $Counter
Add-Content -Value $Value -Path 'C:\HighCPUAlert.log'
        ## Emails devops log errors are detected
        $body = " Error. $Value on $hostname"
        $emailFrom = "$hostname@company.com"
        $emailTo = "devops@company.com"
        $subject = "$hostname - Cpu Usage Notification"
        $smtpServer = "mail.company.com"
        $smtp = new-object Net.Mail.SmtpClient($smtpServer)
        $smtp.Send($emailFrom, $emailTo, $subject, $body)




$pair = $true,$false
@(foreach($a in $pair ) {
     foreach($b in $pair ) {
         foreach($c in $pair ) {
             [pscustomobject]@{
                A = $a
                B = $b
                C = $c
                Test = $a -xor $b -xor $c
                NotTest = -not ( $a -xor $b -xor $c)
                Test2 = -not $a -xor -not $b -xor -not $c
             }
         }
    }
}
) | ft -auto | rg 'True|$'

$pair = 0,1
@(foreach($a in $pair ) {
     foreach($b in $pair ) {
         foreach($c in $pair ) {
             [pscustomobject]@{
                A = $a
                B = $b
                C = $c
                Test = $a -xor $b -xor $c
                NotTest = -not ( $a -xor $b -xor $c)
                Test2 = -not $a -xor -not $b -xor -not $c
             }
         }
    }
}
) | ft -auto | rg 'True|$'