#!/bin/bash
#
# pu.sh
# Copyright (C) 2023  Jan Mosig
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# pu.sh - Package Update. Automates updating the local package cache and installing the latest updates.
# Requires apt based package management.
#
# See https://github.com/JanMosigItemis/productivity_scripts
#
set -e
apt update
apt list --upgradable
read -p "Do you want to proceed? (y/n) " yn

case $yn in
	[yY] ) echo Proceeding..;;
	[nN] ) echo exiting..;
		exit 0;;
	* ) echo invalid input;
		exit 1;
esac
apt-get upgrade
