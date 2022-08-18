<#
This script checks two IP adresses for belonging to the same network
"ip_address_1", value IP address in the format x.x.x.x
"ip_address_2", value IP address in the format x.x.x.x
"network_mask", value in in the format x.x.x.x or xx

#>
param (
    [Parameter(Mandatory = $true)]
    [System.Net.IPAddress] $ip_address_1,
    [Parameter(Mandatory = $true)]
    [System.Net.IPAddress] $ip_address_2,
    [Parameter(Mandatory = $true)]
    [string] $network_mask
)
process{
    [bool]$differentNetwork = $false;
    $RegExMask="\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" #regular expression for checking mask format 
    if ($network_mask -notmatch $RegExMask) {  
        
        if (([int]::Parse($network_mask) -lt 32)) {
            $network_mask = ("1" * $network_mask) + ("0" * (32 - $network_mask))       #generate net mask from CIDR
            [System.Net.IPAddress]$network_mask = [System.Net.IPAddress] ([Convert]::ToUInt64($network_mask, 2))
        }else{
            Write-Host "WRONG NETWORK MASK " $network_mask -ForegroundColor 'Red'
            exit
        }
    }else {
        [System.Net.IPAddress]$network_mask = [System.Net.IPAddress]::Parse($network_mask)  
    }
        
    Write-Host "First IPAddress = "$ip_address_1
    Write-Host "Second IPAddress= "$ip_address_2
    Write-Host "Network Maks    = "$network_mask
    $ip1 = $ip_address_1.GetAddressBytes()      # getting array of octets
    $ip2 = $ip_address_2.GetAddressBytes()
    $mask = $network_mask.GetAddressBytes()
    for ($i = 0; $i -lt $ip1.Count; $i++) {     # make bitwise AND for ip_address_1 and ip_address_2 to MASK per octet
        if (($ip1[$i] -band $mask[$i]) -ne ($ip2[$i] -band $mask[$i])) {
            Write-Host "NO" -ForegroundColor 'Red'
            $differentNetwork = $true;       
            break;
        }
    }    
    if (!$differentNetwork) {    
        Write-Host "Yes" -ForegroundColor 'Green'
    }   
}