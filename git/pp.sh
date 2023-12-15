#!/bin/bash

# pp.sh
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
# pp - "pull pull" - A script that automatically updates all git repositories in its current working directory.
# Call with ./pp
# 1. Enters next subdir if it contains a .git directory.
# 2. Stashes away uncommitted changes on currently checked out feature branch.
# 3. Checks out main branch.
# 4. Fetches all changes and tags from remote for all branches.
# 5. Merges changes into main branch.
# 6. Checks out your feature branch if it was checked out at the start of the script.
# 7. Calls stash apply
# 8. Continue with 1
#
# If called with ./pp branches the script just analyses current state of branches, i. e.
# * Main branch checked out -> no output
# * Other branch checked out and no uncommitted changes -> print repo name in yellow
# * Other branch checked out and has uncommitted changes -> print repo name in red
#
# Requires https://github.com/JanMosigItemis/productivity_scripts/blob/main/bash/lib.sh

. lib.sh
set -e

main_branch() {
  echo $(git remote show origin | awk '/HEAD branch:/ {print $NF}')
}

current_branch() {
  echo $(git symbolic-ref --short HEAD)
}

cd_cwd() {
  cd "${cwd}"
}

update() {
  echo -ne "\e]0;Now updating $1\a"
  echo
  echo -e "${GREEN}--> Now updating $1${NC}"
  cd "$1"
  MAIN_BRANCH=$(main_branch)
  git stash clear || { return 1 ; }
  OLD_BRANCH=$(current_branch) ||  { echo "${YELLOW}$1 is in detached-state. Skipping update.${NC}" ; cd_cwd ; return 1 ; }
  git stash || { cd_cwd; return 1 ; }
  git checkout "${MAIN_BRANCH}" || { cd_cwd; return 1 ; }
  git fetch -p --tags --force && git pull || { cd_cwd; return 1 ; }
  git submodule update --remote --merge
  git checkout $OLD_BRANCH || { cd_cwd; return 1 ; }
  # Returns 1 if no stash entries found
  git stash apply
  git stash clear || { cd_cwd; return 1 ; }
  cd_cwd
}

branches() {
  cd "$1"
  MAIN_BRANCH=$(main_branch)
  CURRENT_BRANCH=$(current_branch) ||  { echo "${YELLOW}$1 is in detached-state. Skipping update.${NC}" ; return 1 ; }

  OUTPUT=""
  if [ "${CURRENT_BRANCH}" != "${MAIN_BRANCH}" ]; then
    OUTPUT="${YELLOW} $1\n"
  fi
  if [[ "$(git status)" != *"working tree clean"* ]]; then
    OUTPUT="${RED} $1\n"
  fi
  echo -ne "${OUTPUT}"
  cd_cwd
}

collect_projects() {
  local found_dirs
  while IFS=  read -r -d $'\0'; do
    found_dirs+=("${REPLY}")
  done < <(find . -mindepth 1 -maxdepth 1 -type d -printf '%P\0')

  for dir in "${found_dirs[@]}" ; do
    if [ -d "${dir}/.git" ]; then
      projects+=("${dir}")
    fi
  done
}

declare -g cwd="${PWD}"
declare -ga projects=()
collect_projects;

if [ "$1" = "branches" ]; then
  echo -e "${GREEN}--> Analysing branches..${NC}"
  for i in "${projects[@]}"
  do
    branches "${i}" || exit 1
  done
else
  for current_project in "${projects[@]}"
  do
    { update "${current_project}" ; } || { end_with_error "Git updated failed." ; }
  done
  echo -e "${GREEN}<-- SUCCESS${NC}"
fi
