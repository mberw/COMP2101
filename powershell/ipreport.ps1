"Currently enabled Network Adapters are:"
get-ciminstance -class win32_networkadapterconfiguration | ? ipenabled


"********************"
"Below is a table containing additional details about the network adapters listed above"
"********************"
get-ciminstance -class win32_networkadapterconfiguration | where-object ipenabled | ? {$_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null} | select description, dnsserversearchorder, dnsdomain, dnshostname, dns-server, ipaddress, index, ipsubnet | format-table -autosize









