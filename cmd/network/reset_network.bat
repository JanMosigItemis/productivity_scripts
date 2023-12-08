REM reset_network.bat
REM Copyright (C) 2023  Jan Mosig

REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM any later version.

REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.

REM You should have received a copy of the GNU General Public License
REM along with this program.  If not, see <http://www.gnu.org/licenses/>.

REM https://github.com/JanMosigItemis/productivity_scripts

@ECHO OFF

REM A script that tries to reset essential Windows network things.
REM Renews DHCP leases and flushes the DNS cache.

netsh winsock reset
netsh int ip reset
ipconfig/release
ipconfig/renew
ipconfig/flushdns