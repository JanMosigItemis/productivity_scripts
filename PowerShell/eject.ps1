# eject.ps1
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

# Perform a "hard eject" (open tray) on the drive registered as "CD-ROM 0" which is usually the first known optical drive.
# Set to "item(1)", "item(2)".. respectively if you want to perform eject on other drives.
# Tested on Windows 11

# Code is deprecated
# Maybe replace with https://stackoverflow.com/a/35707334/22155582 ?
(New-Object -com "WMPlayer.OCX.7").cdromcollection.item(0).eject()