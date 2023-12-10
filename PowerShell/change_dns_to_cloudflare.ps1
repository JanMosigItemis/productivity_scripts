# change_dns_to_cloudflare.ps1
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

# Set primary and secondary DNS server addresses (both IPv4 and IPv6) for specified network interfaces to Cloudflare DNS addresses.
# Be aware: Your network interfaces may have different names. Please adapt.
# Tested with Windows 10

Set-DnsClientServerAddress -InterfaceAlias "WLAN" -ServerAddresses "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001"
