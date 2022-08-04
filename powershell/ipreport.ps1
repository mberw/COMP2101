
#Let the user know which network adapters are active/enabled on the system

"Currently enabled Network Adapters are:"
get-ciminstance -class win32_networkadapterconfiguration | ? ipenabled

<#Give the user more details about the network adapters listed above. 
Here we're getting the network adapter class from get-ciminstance that are listed as enabled where the win32_networkadapterconfiguration properties are not equal (-ne) to nothing ($null)
#>
"********************"
"Below is a table containing additional details about the network adapters listed above"
"********************"
get-ciminstance -class win32_networkadapterconfiguration | where-object ipenabled | ? {$_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null} | select description, dnsserversearchorder, dnsdomain, dnshostname, ipaddress, index, ipsubnet | format-table -autosize









