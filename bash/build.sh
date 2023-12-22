#!/bin/bash
#
# build.sh
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
# build.sh - Build all maven projects in current working dir.
# Goes into each subdir and calls mvn -U clean install if it contains a pom.xml.
# You may provide custom build args by placing a file called 'ps_build_goals' into <PROJECT>/.mvn.
# The first line of this file is passed as is to mvn as build args.
#
# The order in which projects are built is alphabetical.
# You may provide a sub dir name to skip, i. e. of sub projects a, b and c if called like './build.sh c' it will start
# with c and skip everything that comes before c.
#
# See https://github.com/JanMosigItemis/productivity_scripts
# Requires https://github.com/JanMosigItemis/productivity_scripts/blob/main/bash/lib.sh in the same directory.

. lib.sh

collect_projects() {
  local found_dirs
  local default_goals="-U clean install"
  while IFS=  read -r -d $'\0'; do
    found_dirs+=("${REPLY}")
  done < <(find . -mindepth 1 -maxdepth 1 -type d -printf '%P\0')

  for dir in "${found_dirs[@]}" ; do
    if [ -f "${dir}/pom.xml" ]; then
      goals=$(tail -n +1 $dir/.mvn/ps_build_goals 2>/dev/null)
      if [ -z "${goals}" ] ; then goals="${default_goals}" ; fi
      projects+=("${dir}" "${goals}")
    fi
  done
}

build() {
  echo -ne "\e]0;Now building $1\a"
  echo
  echo -e "${GREEN}--> Now building $1${NC}"
  cd "$1"
  echo "mvn args: $2 ${@:3}"
  mvn "$2" "${@:3}" || { end_with_error "Build for $1 failed." ; }
  cd_cwd
}

args="$@"
declare -ga projects=()
declare -g start_here
collect_projects;

start_here="${projects[0]}"

IFS=" "
read -ra args_array <<< "$args"
args_size=${#args_array[@]}
if [ $args_size -gt 0 ]; then
start_here_candidate="${args_array[$args_array-1]}"
  if [[ "${projects[@]}" =~ "${start_here_candidate}" ]]; then
    start_here="${start_here_candidate}"
    args=${args_array[@]::$args_size-1}
  else
    echo -e "${RED}Unknown project: $start_here_candidate${NC}"
    exit 1
  fi
fi

if [ -z "${start_here}" ] ; then
  echo -e "${YELLOW}No viable maven project found.${NC}"
else
  echo "Starting with $start_here"

  skip=true
  for (( i=0; i<${#projects[@]}; i=i+2 ));
  do
    if [[ $skip == "false" ]] || [[ "${projects[i]}" == "${start_here}" ]]; then
      skip=false
      build_args="${args} ${projects[i+1]}"
      build ${projects[i]} ${build_args}
    elif [[ $skip == "true" ]]; then
      echo -e "${YELLOW}--> Skipping build of ${projects[i]}${NC}"
    fi
  done

 echo -e "${GREEN}<-- FINISHED${NC}"
fi
