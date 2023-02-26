#Connect to your Azure Account
Connect-AzAccount

#Defines baseline variables
$Subscriptions = Get-AzSubscription
$path = "c:\temp\WebAppTLS.csv"
       
#Sets working context to a single subscription, defines the $apps variable, and runs the next foreach function. This is reiterated for each subscription.
foreach ($sub in $Subscriptions) {
           Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
           $apps = (Get-AzWebApp).Name
                
                #Retrieves the minimum TLS version enforced by each web app (App Service), converts both the $app and $tls variables into custom objects with properties,
                #and exports those properties to a CSV file. 
                foreach ($app in $apps){
                     $tls = (Get-AzWebApp -Name $app).Siteconfig.MinTlsVersion 
                     $webapps = New-Object PSObject
                     $webapps | Add-Member -MemberType NoteProperty $app -Name 'Site'
                     $webapps | Add-Member -MemberType NoteProperty $tls -Name 'Min TLS Version'
                     $webapps | Export-CSV -Path $path -append -notypeinformation
                } 
        }

Write-host ('The file is available at ' + ($path))

Read-Host -Prompt "Press Enter to exit"