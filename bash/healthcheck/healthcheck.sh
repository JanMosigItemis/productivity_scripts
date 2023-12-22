#!/bin/bash
#
# healthcheck.sh
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
# healthcheck.sh - Perform a custom healthcheck on your system. This is
# the main script. It iterates through all scripts in subfolder 'modules'
# and executes them. Each script in 'modules' is supposed to have the same
# structure and behavior. Each such script shall perform healthchecks on
# one particular subsystem, like raid or mail. See examples for details.
#
# See https://github.com/JanMosigItemis/productivity_scripts
#
# exit if a command fails
set -e
# exit if undeclared variable is used
set -u

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ALL_GOOD=true

for module_file in `ls ${SCRIPT_DIR}/modules`; do
  unset module_name
  unset module_status
  unset module_functions
  . "${SCRIPT_DIR}/modules/${module_file}"
  if [ ! -v module_status ] ; then
    echo "${module_name}"
    for (( i=0; i<${#module_functions[@]}; i=i+2 )); do
      echo -n "    ${module_functions[$i]}"
      func=$((i+1))
      if ${module_functions[$func]} >/dev/null 2>&1; then
        echo -e " ${GREEN}✔"
      else
        ALL_GOOD=false
        echo -e " ${RED}✖"
      fi
      echo -en "${NC}"
    done
  fi
done

if [ "$ALL_GOOD" = "true" ]; then
  echo -e "${GREEN}👍👍👍"
else
  echo -e "${RED}✖✖✖"
fi
