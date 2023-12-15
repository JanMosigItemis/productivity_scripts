#!/bin/bash

# lib.sh
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

# Helper library for shell scripts.
# Just source within your scripts like this:
# . lib.sh
# See https://github.com/JanMosigItemis/productivity_scripts

# Use with echo -e and don't forget to reset the colors, e. g.
# echo -e "${GREEN}This message is printed in green color.${NC}"
if [[ -z "${WORKDIR}" ]] ; then declare -r WORKDIR="${PWD}" ; fi
if [[ -z "${RED}" ]] ; then declare -r RED='\033[0;31m' ; fi
if [[ -z "${GREEN}" ]] ; then declare -r GREEN='\033[0;32m' ; fi
if [[ -z "${YELLOW}" ]] ; then declare -r YELLOW='\033[0;33m' ; fi
if [[ -z "${NC}" ]] ; then declare -r NC='\033[0m' ; fi # No Color

# Exit the script with code 1.
#
# Arg 1: Text to display before exiting.
# Usage: <cmd> || { end_with_error "cmd failed." ; }
#
end_with_error()
{
  echo -e "${RED}ERROR: ${1:-"An error occurred"} Exiting.${NC}" 1>&2
  exit 1
}

#
# Display a message and wait for the user to make a decision. Only accepts yY or nN. Loops for as long as no valid value has been entered.
#
# Arg 1: Message to display before the prompt.
#
# Return: true if yY, false if nN or empty (i. e. user just hit enter).
# Usage: if $(are_you_sure "Operation") ; then perform_operation ; else do_not_perform_operation ; fi
are_you_sure() {
  while true; do
    local _yn=n
    read -p "${1} (y/[n])? " _yn
    case $_yn in
      [Yy]* ) echo true; break;;
      [Nn]* ) echo false; break;;
      ""    ) echo false; break;;
    esac
  done
}

#
# Remove any leading and trailing spaces or space like characters.
#
# Arg 1: String to trim.
#
# Return: Trimmed string
#
trim()
{
  # See https://www.linuxjournal.com/content/return-values-bash-functions
  echo "$(echo -e "${1}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
}

#
# Holds the script until the user presses a key.
#
# -n1.. read exactly one char
# -s... do not echo any input
# -r... escaping via backslash is not allowed
# -p... output the following string without a newline before reading
#
press_any_key() {
  read -n 1 -s -r -p $'Press any key to continue\n'
  echo
}

# Return the name of the default branch. Current working dir must be a git repository.
main_branch() {
  echo $(git remote show origin | awk '/HEAD branch:/ {print $NF}')
}

# Return the name of the currently checked out branch. Current working dir must be a git repository.
current_branch() {
  echo $(git symbolic-ref --short HEAD)
}

# Change back to the directory that was the current working directory when lib.sh has first been called.
cd_cwd() {
  cd "${WORKDIR}"
}