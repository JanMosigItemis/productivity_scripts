# change_dns_to_dhcp.ps1
#
# Copyright (C) 2023  Jan Mosig
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# https://github.com/JanMosigItemis/productivity_scripts

# Reset primary and secondary DNS server addresses (both IPv4 and IPv6) for specified network interfaces to "default" which often means: Use DHCP.
# Be aware: Your network interfaces may have different names. Please adapt.
# Tested with Windows 10

Set-DnsClientServerAddress -InterfaceAlias "WLAN" -ResetServerAddresses
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ResetServerAddresses