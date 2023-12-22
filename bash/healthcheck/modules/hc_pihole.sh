#!/bin/bash
#
# hc_pihole.sh
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
# hc_pihole.sh - Real world example of a healthcheck module. It checks
# if your local pihole setup is functional.
#
# See https://pi-hole.net
# See https://github.com/JanMosigItemis/productivity_scripts
#
function hc_pihole_dig() {
  dig @127.0.0.1 -p 53 dnssec.works | grep -i "status\: NOERROR"
}

function hc_pihole_unbound() {
  systemctl --no-pager status unbound && dig @127.0.0.1 -p 5335 dnssec.works | grep -i "status\: NOERROR"
}

function hc_pihole_ftl() {
  systemctl --no-pager status pihole-FTL
}

function hc_pihole_web() {
  curl -L http://127.0.0.1 | grep "value=\"pi\.hole\""
}

module_name="PiHole"
module_functions=("dig" "hc_pihole_dig" "unbound" "hc_pihole_unbound" "FTL" "hc_pihole_ftl" "WebUI" "hc_pihole_web")

