# IP Configuration Report 

Get-CimInstance -class win32_networkadapterconfiguration  | 
Where-Object {$_.ipenabled -eq "True"} | 
Format-Table Description,Index,IpAddress,IpSubnet,DnsDomain,DnsServerSearchOrder