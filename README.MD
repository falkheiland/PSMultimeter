# PSMultimeter

Powershell Module / Tools for the use with the product Multimeter of Allegro Packets (<https://allegro-packets.com/de/>)

## Functions

* [Get-MultimeterArpStatistic](#get-multimeterarpstatistic)
* [Get-MultimeterDisk](#get-multimeterdisk)
* [Get-MultimeterInterfaceStatistics](#get-multimeterinterfacestatistics)
* [Get-MultimeterIpStatistics](#get-multimeteripstatistics)
* [Get-MultimeterLocationStatistics](#get-multimeterlocationstatistics)
* [Get-MultimeterMacProtocol](#get-multimetermacprotocol)
* [Get-MultimeterMacStatistics](#get-multimetermacstatistics)
* [Get-MultimeterNotification](#get-multimeternotification)
* [Get-MultimeterPacketSize](#get-multimeterpacketsize)
* [Get-MultimeterStorage](#get-multimeterstorage)
* [Get-MultimeterStpStatistic](#get-multimeterstpstatistic)
* [Get-MultimeterSystemInfo](#get-multimetersysteminfo)
* [Get-MultimeterTime](#get-multimetertime)
* [Get-MultimeterVlanStatistic](#get-multimetervlanstatistic)

### Get-MultimeterArpStatistic

Get Arp Statistics

**Asks for credential then gets Arp-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets Arp-Statistics for the last 1 hour:**

```powershell
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -Timespan 3600
```

**Gets ARP MAC information:**

```powershell
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -MACInformation
```

**Gets MAC Address for the Host with most bytes in the last hour:**

```powershell
(Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -MACInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.mac
```

**Gets ARP MAC information:**

```powershell
Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -IPInformation
```

**Gets IP Address for the Host with most bytes in the last hour:**

```powershell
(Get-MultimeterArpStatistic -Hostname 'allegro-mm-6cb2' -IPInformation -SortBy bytes -Reverse -Page 0 -Count 1 -Timespan 60).displayedItems.ip
```

### Get-MultimeterDisk

Get Disk information

**Asks for credential then gets disks from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterDisk -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets disks from Allegro Multimeter that are connected via USB:**

```powershell
(Get-MultimeterDisk -Hostname 'allegro-mm-6cb2').where{$_.transport -eq 'usb'}
```

### Get-MultimeterInterfaceStatistics

Get interface statistics

**Asks for credential then interface statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterInterfaceStatistics -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Get interface statistics from Allegro Multimeter for interfaces that are connected:**

```powershell
((Get-MultimeterInterfaceStatistics -Hostname 'allegro-mm-6cb2').interfaces).where{$_.linkDetected -eq 'True'}
```

### Get-MultimeterIpStatistics

Get IP statistics

**Asks for credential then gets IP-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets IP-Statistics for the IP Address with the most Bytes in the last 1 hour:**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
```

**Gets IP-Statistics for the IP Address with the most Bytes in the last 1 hour from Location Germany:**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -Timespan 3600 -SortBy Bytes -Page 0 -Count 1 -Reverse -Location 'DE'
```

**Gets overview of IP-Statistics for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Overview
```

**Gets IP-Statistics for Protocols for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Protocols
```

**Gets Bytes received from for Protocol Youtube for IP Address '192.168.0.1' during the last 60 seconds :**

```powershell
(Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Timespan 60 -Protocols).protocols.Youtube.bytesFrom
```

**Gets IP-Statistics for Peers for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Peers
```

**Gets the Peer for IP Address '192.168.0.1' with te most Bytes used and converts its Geolocation to Google Maps URL:**

```powershell
$Peer = (Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems
'http://maps.google.com/?ll={0},{1}' -f ($Peer.latitude -replace(',','.')), ($Peer.longitude -replace(',','.'))
```

**Gets IP-Statistics for Connections for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Connections
```

**Gets DNS Name of the Server with the 3rd most Connections to IP Address '192.168.0.1':**

```powershell
(Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Connections -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.server.dnsName
```

**Gets IP-Statistics for Ports for IP Address '192.168.0.1':**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -IPAddress '192.168.0.1' -Ports
```

**Gets Global IP-Statistics::**

```powershell
Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -Global
```

**Gets Retransmissions in Percent from Global IP-Statistics**:

```powershell
$Stats = (Get-MultimeterIpStatistics -Hostname 'allegro-mm-6cb2' -Global).tcpStats
'Retransmissions: {0}%' -f [math]::Round(($Stats.globalRetransmissionBytes*100/$Stats.globalTotalBytes),3)
```

### Get-MultimeterLocationStatistics

Get Location Statistics

**Asks for credential then gets Location-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterLocationStatistics -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets Code for the 10 Locations with most Bytes:**

```powershell
(Get-MultimeterLocationStatistics -Hostname 'allegro-mm-6cb2' -SortBy bytes -Page 0 -Count 10 -Reverse).displayedItems.code
```

**Gets Location-Statistics for the Location with the most Bytes in the last 1 hour:**

```powershell
Get-MultimeterLocationStatistics -Hostname 'allegro-mm-6cb2' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
```

**Gets overview of Location-Statistics for Location 'DE':**

```powershell
Get-MultimeterLocationStatistics -Hostname 'allegro-mm-6cb2' -Location 'DE'
```

### Get-MultimeterMacProtocol

Get MAC protocols

**Asks for credentail then gets MAC protocols from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets all Time counters for MAC protocols:**

```powershell
(Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb2').globalCounters.allTime
```

**Gets MAC protocols:**

```powershell
Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb2' -Protocols
```

**Gets MAC protocols:**

```powershell
Get-MultimeterMacProtocol -Hostname 'allegro-mm-6cb2' -Protocols 
```

### Get-MultimeterMacStatistics

Get MAC Statistics

**Asks for credential then gets MAC-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets MAC-Statistics for the MAC with the most Bytes in the last 1 hour:**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -Timespan 3600 -SortBy Bytes -Count 1 -Reverse
```

**Gets overview of IP-Statistics for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Overview
```

**Gets MAC-Statistics for Protocols for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Protocols
```

**Gets Bytes received from for Protocol Youtube for MAC Address 'b4:ea:e4:87:3d:89' during the last 60 seconds:**

```powershell
((Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Timespan 60 -Protocols -Page 0 -Count 99).displayedItems).where{$_.protocol -eq 'youtube'}
```

**Gets MAC-Statistics for Peers for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Peers
```

**Gets DHCP Name of the Peer for MAC Address 'b4:ea:e4:87:3d:89' with te most Bytes used:**

```powershell
(Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Peers -SortBy Bytes -Reverse -Count 1).displayedItems.dhcpHostName
```

**Gets MAC-Statistics for Connections for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -ActiveIPs
```

**Gets DNS Name of the Server with the 3rd most Connections to MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
(Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -ActiveIPs -SortBy Bytes -Reverse -Page 3 -Count 1).displayedItems.dnsName
```

**Gets MAC-Statistics for Ports for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -PeerCountries
```

**Gets MAC-Statistics for Vlans for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Vlans
```

**Gets MAC-Statistics for Vlans which are not the default VLAN for MAC Address 'b4:ea:e4:87:3d:89':**

```powershell
((Get-MultimeterMacStatistics -Hostname 'allegro-mm-6cb2' -MACAddress 'b4:ea:e4:87:3d:89' -Vlans).displayedItems).Where{$_.outerVlanTag -ne '-1'}
```

### Get-MultimeterNotification

Get notifications

**Asks for credentail then gets notifications from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterNotification -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

### Get-MultimeterPacketSize

Get packet size (distribution)

**Asks for credential then gets packet size (distribution) from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets all time packet count from Allegro Multimeter for packet size 1519-1522 bytes:**

```powershell
((Get-MultimeterPacketSize -Hostname 'allegro-mm-6cb2').globalCounters.allTime)[6]
```

### Get-MultimeterStorage

Get Storage information

**Asks for credential then gets storgae from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterStorage -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets storage from Allegro Multimeter and checks if it is in use:**

```powershell
(Get-MultimeterStorage -Hostname 'allegro-mm-6cb2' -Credential $Credential).device.isInUse
```

### Get-MultimeterStpStatistic

Get STP Statistics

**Asks for credential then gets STP statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterStpStatistic -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

### Get-MultimeterSystemInfo

Get System Info

**Asks for credential then gets system info from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterSystemInfo -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets uptime in days from Allegro Multimeter:**

```powershell
[math]::Round((((Get-MultimeterSystemInfo -Hostname 'allegro-mm-6cb2').uptimeSec)/86400),2)
```

### Get-MultimeterTime

Get current time

**Asks for credential then gets time from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterTime -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets time from Allegro Multimeter and converts it to .NET Time (DateTime-Format):**

```powershell
Get-MultimeterTime -Hostname 'allegro-mm-6cb2' -DateTime
```

### Get-MultimeterVlanStatistic

Get Vlan Statistics

**Asks for credential then gets Vlan-Statistics from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets Vlan-Statistics for the last 1 hour and shows bytes for VLAN 1:**

```powershell
(((Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb2' -Timespan 3600).displayedItems).where{$_.outerVlanTag -eq -1}).bytes
```

**Gets VLAN Q-inQ statistics:**

```powershell
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb2' -VLANQinQ
```

**Gets statistics for outer VLAN '111':**

```powershell
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb2' -Vlan 111
```

**Gets statistics for outer VLAN '111', no inner VLAN (-1):**

```powershell
Get-MultimeterVlanStatistic -Hostname 'allegro-mm-6cb2' -OuterVlan 111 -InnerVlan -1
```