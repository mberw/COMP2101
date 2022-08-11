#********************
#Functions that gather information about the parts of the machine and places what is gathered in appropriate variables
#to be used when generating the report.
#********************

#Function that gathers general computer system info and places it in a variable. I also made the total memory human readable in GB
#and then formated as a list as per the Lab instructions
function Get-Computerinfo {
$pc = Get-CimInstance -ClassName win32_computersystem | select Domain, Manufacturer, Model, PrimaryOwnerName, @{Name="RAM size(GB)";Expression={("{0:N2}" -f($_.TotalPhysicalMemory/1gb))}} | Format-List
$pc
}

#Function that gathers the name and version of the OS and places it in a variable for use in the report later in the script
function Get-Os {
$os = Get-CimInstance -ClassName win32_operatingsystem | select Name, Version | Format-List 
$os
}

#Function that gathers cpu information and places it in the cpu variable for use in the report
function Get-Cpu {
$cpu = Get-CimInstance -ClassName win32_processor | select Name, Description, Currentclockspeed, numberofcores | Format-List
$cpu
}

#The following two functions gather just the amount of cache for L2 and L3 respectively and places the date in a relevant variable for
#later use in the report
function Get-L2cache {
$L2cache = Get-CimInstance -ClassName win32_processor | foreach {$_.L2Cachesize}
$L2cache
}

function Get-L3cache {
$L3cache = Get-CimInstance -ClassName win32_processor | foreach {$_.L3Cachesize}
$L3cache
}

#We need to convert the default capacity (which is in bytes) to GB to make it easier to read/understand (number of gigs with two decimals)
function Get-Ram {
$ram = Get-CimInstance -ClassName win32_physicalmemory | select description, @{Name="RAM size(GB)";Expression={("{0:N2}" -f($_.Capacity/1gb))}},
 BankLabel, Vendor | Format-Table -AutoSize                     
$ram
}


#This Function gets just the amount of ram, separate from the output of the get-ram function to be displayed after
#the physical memory table as a summary line as per lab instructions
function Get-Ram-Amount {
$totalram = Get-CimInstance -ClassName win32_physicalmemory | foreach {$_.Capacity/1gb}
$totalram
}


#Function that gathers video card info and places it in a variable for use in the report later in the script
function Get-Video {
$video = Get-CimInstance -ClassName win32_videocontroller | select Description, VideoProcessor, VideoModeDescription | Format-List
$video
}


function Get-Vertical-Res {
$vertical = Get-CimInstance -ClassName win32_videocontroller | select CurrentVerticalResolution | foreach {$_.CurrentVerticalResolution}
$vertical
}

function Get-Horizontal-Res {
$horizontal = Get-CimInstance -ClassName win32_videocontroller | select CurrentHorizontalResolution | foreach {$_.CurrentHorizontalResolution}
$horizontal
}

#This function was the main part of my Lab 3 network adapter script. I included it here in this function to meet the requirement of
#this lab to include it.
function Get-Nic {
get-ciminstance -class win32_networkadapterconfiguration | where-object ipenabled | ? {$_.dnsdomain -ne $null -or $_.dnshostname -ne $null -or $_.dnsserversearchorder -ne $null} | select description, dnsserversearchorder, dnsdomain, dnshostname, ipaddress, index, ipsubnet | format-table -autosize
}



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