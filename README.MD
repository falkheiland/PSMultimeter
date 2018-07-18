# PSMultimeter

Powershell Module / Tools for the use with the product Multimeter of Allegro Packets (<https://allegro-packets.com/>)

## Interface stats

* Get-MultimeterInterface

## Generic

### Storage

* Get-MultimeterStorage

## Ethernet

### MAC Statistics

* Get-MultimeterMacAddress
* Get-MultimeterMacAddressCountry
* Get-MultimeterMacAddressOverview
* Get-MultimeterMacAddressPeer
* Get-MultimeterMacAddressProtocol
* Get-MultimeterMacAddressVlan

### Packet size distribution

* Get-MultimeterPacketSize

### ARP Statistics

* Get-MultimeterArpIp
* Get-MultimeterArpMac
* Get-MultimeterArpOverview

### VLAN

* Get-MultimeterVlan
* Get-MultimeterVlanInner
* Get-MultimeterVlanOuterInner
* Get-MultimeterVlanOverview

### MAC Protocol Statistics

* Get-MultimeterMacProtocol
* Get-MultimeterMacProtocolOverview

### STP Statistics

* Get-MultimeterStpStatistic

## IP

### IP Statistics

* Get-MultimeterIpAddress
* Get-MultimeterIpAddressConnection
* Get-MultimeterIpAddressOverview
* Get-MultimeterIpAddressPeer
* Get-MultimeterIpAddressProtocol
* Get-MultimeterIpAddressTcpPort
* Get-MultimeterIpGlobalStatistic

### Geolocation

* Get-MultimeterLocation
* Get-MultimeterLocationOverview

### DHCP Statistics

* Get-MultimeterDhcpGlobalMessageType
* Get-MultimeterDhcpGlobalResponseTime
* Get-MultimeterDhcpOverview
* Get-MultimeterDhcpServer

### DNS Statistics

* Get-MultimeterDisk
* Get-MultimeterDnsIp
* Get-MultimeterDnsResponseTime
* Get-MultimeterDnsServer

### NetBIOS Statistics

* Get-MultimeterNetbiosStatistic

### ICMP Statistics

* Get-MultimeterIcmp

### Multicast Statistics

* Get-MultimeterMulticastGroup
* Get-MultimeterMulticastOverview

## Transport

### TCP Statistics

* Get-MultimeterTcpInvalidConnection
* Get-MultimeterTcpRetransmission
* Get-MultimeterTcpStatistic

### L4 Server Ports

* Get-MultimeterL4PortTcp
* Get-MultimeterL4PortTcpOverview
* Get-MultimeterL4PortUdp

## Application

### SSL Statistics

* Get-MultimeterSslGlobalResponseTime
* Get-MultimeterSslResponse
* Get-MultimeterSslServer
* Get-MultimeterSslTop

### HTTP Statistics

* Get-MultimeterHttpGlobalResponseCode
* Get-MultimeterHttpGlobalResponseTime
* Get-MultimeterHttpResponse
* Get-MultimeterHttpServer

### Layer 7 protocols

* Get-MultimeterDpi

### SMB Statistics

* Get-MultimeterSmbClient
* Get-MultimeterSmbConnection
* Get-MultimeterSmbOverview
* Get-MultimeterSmbServer
* Get-MultimeterSmbShare

### NTP Statistics

* Get-MultimeterNtpStatistic

### RTP Statistics

* Get-MultimeterVoipCodec

## Info

### System Info

* Get-MultimeterInfoSystem
* Get-MultimeterSystemHealth
* Get-MultimeterSystemState

### Status

* Get-MultimeterNotification

## Settings

### Global settings

* Get-MultimeterTime

### User Management

* Get-MultimeterSystemUser

[Go to Top](#psmultimeter)