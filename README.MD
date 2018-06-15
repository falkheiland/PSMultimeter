# PSMultimeter

Powershell Module / Tools for the use with the product Multimeter of Allegro Packets (<https://allegro-packets.com/de/>)

## Functions

* [Get-MultimeterIpStatistics](#get-multimeteripstatistics)
* [Get-MultimeterLocationStatistics](#get-multimeterlocationstatistics)
* [Get-MultimeterTime](#get-multimetertime)

### Get-MultimeterIpStatistics

Get IP statistics

**Asks for credentail then gets IP-Statistics from Allegro Multimeter using provided credential:**

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

**Gets IP-Statistics for Ports for IP Address '192.168.0.1':**

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

**Asks for credentail then gets Location-Statistics from Allegro Multimeter using provided credential:**

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

### Get-MultimeterTime

Get current time of the Allegro Multimeter

**Asks for credentail then gets time from Allegro Multimeter using provided credential:**

```powershell
$Credential = Get-Credential -Message 'Enter your credentials'
Get-MultimeterTime -Hostname 'allegro-mm-6cb2' -Credential $Credential
```

**Gets time from Allegro Multimeter and converts it to .net Time:**

```powershell
[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds([math]::Round(((Get-MultimeterTime -Hostname 'allegro-mm-6cb2').currentTime)/1000)))
```