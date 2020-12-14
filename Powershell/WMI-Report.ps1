# Parameters on the Command line



param ( [switch]$System,             # -System displays the CPU, OS, RAM and Video reports only
        [switch]$Disks,              # -Disks displays the disks report only
        [switch]$Network             # -Network displays the network report only
)


if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
    WMI-objects.ps1
    
}  else {
        ""
        "==========================="
        " System Information Report"
        "==========================="
        if ($System -eq $True) {
            ""
            " Processor"
            "========================="
            (processor_description | Out-String).Trim()
            ""
            " Operating System"
            "========================="
            (operating_system | Out-String).trim()
            ""
            " Memory"
            "========================="
            (ram_memory | Out-String).Trim()
            ""
            " Video Controller"
            "========================="
            (video_controller | Out-String).Trim()
            ""
        } 
        if ($Disks -eq $True) {
            ""
            " Physical Disk Drives"
            "========================="
            (disk_drives | Out-String).Trim() 
            ""
        } 
        if ($Network -eq $True) {
            ""
            " Network Adapter "
            "========================="
            (ip_config | Out-String).Trim()

            ""
           
        }
  }