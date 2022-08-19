#********************
#Functions that gather information about the parts of the machine and places what is gathered in appropriate variables
#to be used when generating the report.
#********************




#Main Script that uses information gathered in functions and displays a report
"******************************************"
"General Computer Information:"
Get-Computerinfo
"******************************************"
"Operating System Information:"
Get-Os
"******************************************"
"CPU Information:"
Get-Cpu
if($L2cache -eq $null){
"L2 cache amount: Data Unavailable"
}
elseif($L2cache -gt 0){
"L2 cache amount:"
$L2cache
}

if($L3cache -eq $null){
"L2 cache amount: Data Unavailable"
}
elseif($L3cache -gt 0){
"L3 cache amount:"
$L3cache
}
" " #added some space for readability


"******************************************"
#Calls the get-ram function to display the RAM information in the report
"RAM Information:"
get-ram
write-host "Total RAM on this machine:" (Get-CimInstance -ClassName win32_physicalmemory | foreach {$_.Capacity/1gb}) "GB"
" " #added some space for readability



"******************************************"
"Video Processor Information:"
get-video

"Additional Resolution Details:"
Write-Output "Vertical Resolution:" (Get-Vertical-Res)
Write-Output "Horizontal Resolution:" (Get-Horizontal-Res)
" "



"******************************************"
"Network Adapter Information:"
get-nic


"******************************************"
#********************
# Gathers information on the diskdrives and partitions on the machine
#********************
"Disk Drive Information:"
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }