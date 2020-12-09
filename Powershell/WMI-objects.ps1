#Lab 4 - Loops and WMI

############################
##      FUNCTIONS         ##
############################


#1. System Hardware - include system hardware description: Manufacturer, Model


function computer_system {
    
    Get-CimInstance win32_computersystem | format-list Manufacturer, Model 
}



#2. Operating system - include o/s name and version #. Need to replace "Caption" with O/S system name or Operating system

function operating_system {
 
    Get-CimInstance win32_operatingsystem |
                               foreach {                                         
        New-Object -TypeName psobject -Property @{    
            "Edition" = $_.caption
            Version = $_.version
        } |
        Format-List Edition, Version 
    }
 }

 

#3. processor description - description, speed, # of cores, sizes of L1, L2, L3 caches

function processor_description {
   
    Get-CimInstance win32_processor | 
        select Name,
               CurrentClockSpeed,
               NumberofCores,
               @{n="L1CacheSize"; e={if($_.L1CacheSize -ne $NULL)
                                        {$L1cache=$_.L1CacheSize} 
                                      else 
                                        {$L1cache = "No data available"};
                                   $L1cache
                                    }
                },

               @{n="L2CacheSize"; e={if($_.L2CacheSize -ne $NULL)
                                        {$L2cache=$_.L2CacheSize} 
                                      else 
                                        {$L2cache = "No data available"};
                                   $L2cache
                                     }
                 },
                 L3CacheSize

                         
     

} 


#4. MEMORY - Summary of the RAM installed with Vendor, description, size, bank and slot for each DIMM as a table. Summary RAM as final line

function ram_memory {

    $totalcapacity = 0
    Get-WmiObject -class win32_physicalmemory |
        foreach {                                         
            New-Object -TypeName psobject -Property @{    
                Manufacturer = $_.manufacturer
                Description = $_.description
                "Size(Mb)" = $_.capacity/1mb
                Bank = $_.banklabel
                Slot = $_.devicelocator
            }
            $totalcapacity += $_.capacity/1mb  
        } |
        Format-Table -AutoSize Manufacturer,Description,"Size(Mb)",Bank, Slot  
    
        "Total RAM: ${totalcapacity} MB"                       
}


#5. Physical Disk Drives - Vendor, Model, Size, and space usage (size, free space, and percentage free) as a table
# one logical disk per per output line

function disk_drives {
    $diskdrive = Get-WmiObject win32_diskdrive
    $diskdetails = foreach ($disk in $diskdrive) {
    $partitions = $disk.getrelated('win32_diskpartition')
        foreach ($partition in $partitions) {
            $logicaldisks = $partition.getrelated('win32_logicaldisk')
                foreach ($logicaldisk in $logicaldisks) {
                    
                    New-Object -TypeName psobject -Property @{ 
                        Manufacturer = $disk.Manufacturer
                        Model = $disk.Model
                        Location = $partition.DeviceID
                        Drive = $logicaldisk.DeviceID
                        "Size(GB)" = $logicaldisk.size/1gb -as [int]   # pulling 60 but my tables show 64?
                        "Free Space(GB)"= $logicaldisk.FreeSpace/1gb -as [int] # Pulling 42 but showing 45 on table?
                        "Percentage Free(%)" = (($logicaldisk.size - $logicaldisk.FreeSpace) * 100  ) / $logicaldisk.Size -as [int]
                    }    # on diskpartition I have two, disk 0 part 0 and disk 0 part 1 - seems like only disk 0 part 1 is showing up
                }
            }
            }
   $diskdetails |
   Format-Table Manufacturer, Model, Location, Drive, "Size(GB)", "Free Space(GB)", "Percentage Free(%)"
} 




#6.network adapter configuration report

function ip_config {
    IPConfigReport.ps1
}

#7. Video controller - include video card vendor, description and current screen resolution

function video_controller {
   
    Get-WmiObject -class win32_videocontroller | 
        foreach {
            New-Object -TypeName psobject -Property @{
                Vendor = $_.AdapterCompatibility
                Description = $_.Description
                "Current Screen Resolution" = ($_.CurrentHorizontalResolution).toString() + " " + "X" + " " + ($_.CurrentVerticalResolution).toString() 
            }
        }|
     Format-List Vendor, Description, "Current Screen Resolution"
}

            # need to add NULL factor

#############################################
####            REPORT                  #####
#############################################
""
""
"========================= "
"System Information Report"
"========================="

""
""
" System Hardware"
"========================="
(computer_system | Out-String).trim() 
""
""
" Operating System"
"========================="
(operating_system | Out-String).trim()

""
""
" Processor"
"========================="
(processor_description | Out-String).Trim()

""
""
" Memory"
"========================="
(ram_memory | Out-String).Trim()

""
""
" Physical Disk Drives"
"========================="
(disk_drives | Out-String).Trim() 
""
""
" Network Adapter "
"========================="
(ip_config | Out-String).Trim()

""
""
" Video Controller"
"========================="
(video_controller | Out-String).Trim()
""
""

                         