# PSMultimeter

Powershell Module / Tools for the use with the product Multimeter of Allegro Packets (<https://allegro-packets.com/>)

## Functions

* [Get-MultimeterArpStatistic](#get-multimeterarpstatistic)
* [Get-MultimeterDhcpStatistic](#Get-multimeterdhcpstatistic)
* [Get-MultimeterDisk](#get-multimeterdisk)
* [Get-MultimeterDnsStatistic](#Get-multimeterdnsstatistic)
* [Get-MultimeterInterfaceStatistic](#get-multimeterinterfacestatistic)
* [Get-MultimeterIpStatistic](#get-multimeteripstatistic)
* [Get-MultimeterLocationStatistic](#get-multimeterlocationstatistic)
* [Get-MultimeterMacProtocol](#get-multimetermacprotocol)
* [Get-MultimeterMacStatistic](#get-multimetermacstatistic)
* [Get-MultimeterNetbiosStatistic](#get-multimeternetbiosstatistic)
* [Get-MultimeterNotification](#get-multimeternotification)
* [Get-MultimeterPacketSize](#get-multimeterpacketsize)
* [Get-MultimeterStorage](#get-multimeterstorage)
* [Get-MultimeterStpStatistic](#get-multimeterstpstatistic)
* [Get-MultimeterSystemInfo](#get-multimetersysteminfo)
* [Get-MultimeterTime](#get-multimetertime)
* [Get-MultimeterVlanStatistic](#get-multimetervlanstatistic)

### Get-MultimeterArpStatistic

Get Arp Statistics

**Ask for credential then get Arp-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get Arp-Statistics for the last 1 hour:**

```powershell
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600
```

**Get ARP MAC information:**

```powershell
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -MACInformation
```

**Get MAC Address for the Host with most bytes in the last hour:**

```powershell
(Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -MACInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.mac
```

**Get ARP MAC information:**

```powershell
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -IPInformation
```

**Get IP Address for the Host with most bytes in the last hour:**

```powershell
(Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb3' -IPInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.ip
```

### Get-MultimeterDhcpStatistic

Get DHCP Statistics

**Ask for credential then get DHCP information from DHCP-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get Hostnames of the first 20 IP Addresses for the last 1 hour:**

```powershell
(Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.hostName
```

**Get DHCP Server information:**

```powershell
Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -DHCPServer
```

**Get DHCP Global response times:**

```powershell
Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -GRT
```

**Get DHCP message types:**

```powershell
Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -MessageTypes
```

**Get number of DHCP messages of type 'request':**

```powershell
(((Get-MultimeterDhcpStatistic -Hostname 'allegro-mm-6cb3' -MessageTypes).where{$_.name -eq 'request'}) |
Select-Object -Property Count).count
```

### Get-MultimeterDisk

Get Disk information

**Ask for credential then get disks from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterDisk -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get disks from Allegro Multimeter that are connected via USB:**

```powershell
(Get-MultimeterDisk -Hostname 'allegro-mm-6cb3').where{$_.transport -eq 'usb'}
```

### Get-MultimeterDnsStatistic

Get DNS Statistics

**Ask for credential then get DNS information from DNS-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get DNS-names of the first 20 IP Addresses for the last 1 hour:**

```powershell
(Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.name
```

**Get DNS Server information:**

```powershell
Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -DNSServer
```

**Get DNS Global response times:**

```powershell
Get-MultimeterDnsStatistic -Hostname 'allegro-mm-6cb3' -GRT
```

### Get-MultimeterInterfaceStatistic

Get interface statistics

**Ask for credential then interface statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterInterfaceStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get interface statistics from Allegro Multimeter for interfaces that are connected:**

```powershell
((Get-MultimeterInterfaceStatistic -Hostname 'allegro-mm-6cb3').interfaces).where{$_.linkDetected -eq 'True'}
```

### Get-MultimeterIpStatistic

Get IP statistics

**Ask for credential then get IP-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get IP-Statistics for the IP Address with the most Bytes in the last 1 hour:**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
```

**Get IP-Statistics for the IP Address with the most Bytes in the last 1 hour from Location Germany:**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Page 0 -Count 1 -Reverse -Location 'DE'
```

**Get overview of IP-Statistics for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Overview
```

**Get IP-Statistics for Protocols for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Protocols
```

**Get Bytes received from for Protocol Youtube for IP Address '192.168.0.1' during the last 60 seconds :**

```powershell
(Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Timespan 60 -Protocols).protocols.Youtube.bytesFrom
```

**Get IP-Statistics for Peers for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Peers
```

**Get the Peer for IP Address '192.168.0.1' with te most Bytes used and converts its Geolocation to Google Maps URL:**

```powershell
$Peer = (Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems
'http://maps.google.com/?ll={0},{1}' -f ($Peer.latitude -replace(',','.')), ($Peer.longitude -replace(',','.'))
```

**Get IP-Statistics for Connections for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Connections
```

**Get DNS Name of the Server with the 3rd most Connections to IP Address '192.168.0.1':**

```powershell
(Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Connections -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.server.dnsName
```

**Get IP-Statistics for Ports for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -IPAddress '192.168.0.1' -Ports
```

**Get Global IP-Statistics::**

```powershell
Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Global
```

**Get Retransmissions in Percent from Global IP-Statistics**:

```powershell
$Stats = (Get-MultimeterIpStatistic -Hostname 'allegro-mm-6cb3' -Global).tcpStats
'Retransmissions: {0}%' -f [math]::Round(($Stats.globalRetransmissionBytes*100/$Stats.globalTotalBytes),3)
```

### Get-MultimeterLocationStatistic

Get Location Statistics

**Ask for credential then get Location-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get Code for the 10 Locations with most Bytes:**

```powershell
(Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -SortBy bytes -Page 0 -Count 10 -Reverse).displayedItems.code
```

**Get Location-Statistics for the Location with the most Bytes in the last 1 hour:**

```powershell
Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
```

**Get overview of Location-Statistics for Location 'DE':**

```powershell
Get-MultimeterLocationStatistic -Hostname 'allegro-mm-6cb3' -Location 'DE'
```

### Get-MultimeterMacProtocol

Get MAC protocols

**Ask for credentail then get MAC protocols from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get all Time counters for MAC protocols:**

```powershell
(Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3').globalCounters.allTime
```

**Get MAC protocols:**

```powershell
Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb3' -Protocols
```

### Get-MultimeterMacStatistic

Get MAC Statistics

**Ask for credential then get MAC-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get MAC-Statistics for the MAC with the most Bytes in the last 1 hour:**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
```

**Get overview of IP-Statistics for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Overview
```

**Get MAC-Statistics for Protocols for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Protocols
```

**Get Bytes received from for Protocol Youtube for MAC Address 'b4:ea:e4:87:3d:89' during the last 60 seconds:**

```powershell
((Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Timespan 60 -Protocols -Page 0 -Count 99).displayedItems).where{$_.protocol -eq 'youtube'}
```

**Get MAC-Statistics for Peers for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Peers
```

**Get DHCP Name of the Peer for MAC Address 'b4:ea:e4:87:3d:89' with te most Bytes used:**

```powershell
(Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems.dhcpHostName
```

**Get MAC-Statistics for Connections for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -ActiveIPs
```

**Get DNS Name of the Server with the 3rd most Connections to MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
(Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -ActiveIPs -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.dnsName
```

**Get MAC-Statistics for Ports for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -PeerCountries
```

**Get MAC-Statistics for Vlans for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Vlans
```

**Get MAC-Statistics for Vlans which are not the default VLAN for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
((Get-MultimeterMacStatistic -Hostname 'allegro-mm-6cb3' -MACAddress 'b4:ea:e4:87:3d:89' -Vlans).displayedItems).Where{$_.outerVlanTag -ne '-1'}
```

### Get-MultimeterNetbiosStatistic

Get NetBIOS Statistics

**Ask for credential then get DNS information from DNS-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterNetbiosStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get names of the first 20 IP Addresses for the last 1 hour:**

```powershell
(Get-MultimeterNetbiosStatistic -Hostname 'allegro-mm-6cb3' -SortBy 'ip' -Page 0 -Count 20 -Timespan 3600).displayedItems.name
```

### Get-MultimeterNotification

Get notifications

**Ask for credentail then get notifications from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterNotification -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

### Get-MultimeterPacketSize

Get packet size (distribution)

**Ask for credential then get packet size (distribution) from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get all time packet count from Allegro Multimeter for packet size 1519-1522 bytes:**

```powershell
((Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb3').globalCounters.allTime)[6]
```

### Get-MultimeterStorage

Get Storage information

**Ask for credential then get storgae from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterStorage -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get storage from Allegro Multimeter and checks if it is in use:**

```powershell
(Get-MultimeterStorage -Hostname 'allegro-mm-6cb3' -Credential $Credential).device.isInUse
```

### Get-MultimeterStpStatistic

Get STP Statistics

**Ask for credential then get STP statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterStpStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

### Get-MultimeterSystemInfo

Get System Info

**Ask for credential then get system info from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterSystemInfo -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get uptime in days from Allegro Multimeter:**

```powershell
[math]::Round((((Get-MultimeterSystemInfo -Hostname 'allegro-mm-6cb3').uptimeSec)/86400),2)
```

### Get-MultimeterTime

Get current time

**Ask for credential then get time from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterTime -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get time from Allegro Multimeter and converts it to .NET Time (DateTime-Format):**

```powershell
Get-MultimeterTime -Hostname 'allegro-mm-6cb3' -DateTime
```

### Get-MultimeterVlanStatistic

Get Vlan Statistics

**Ask for credential then get Vlan-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -Credential $Credential
```

**Get Vlan-Statistics for the last 1 hour and shows bytes for VLAN 1:**

```powershell
(((Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -Timespan 3600).displayedItems).where{$_.outerVlanTag -eq -1}).bytes
```

**Get VLAN Q-inQ statistics:**

```powershell
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -VLANQinQ
```

**Get statistics for outer VLAN '111':**

```powershell
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -Vlan 111
```

**Get statistics for outer VLAN '111', no inner VLAN (-1):**

```powershell
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb3' -OuterVlan 111 -InnerVlan -1
```