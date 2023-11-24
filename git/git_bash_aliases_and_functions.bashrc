# git_bash_aliases_and_functions.bashrc
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

# Contains bash aliases and helper functions that make working with git on the shell faster.
# Commands are very short on purpose so that entering them is as fast as possible.
# Also commands may be dangerous, i. e. may overwrite data without asking first. Use with care.

# 'force push'
# Can be used to overwrite the last commit and force push it instead of committing every little piece of work with a separate commit.
# THIS IS A DANGEROUS OPERATION! Use with care!
fp() {
  git add .
  git commit --amend --no-edit
  read -p "Really force push? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin -f
  fi
  echo "Last update: $(date +"%Y-%m-%d %H:%M:%S%z")"
}
export -f fp

# 'git merge'
# Does NOT perform a merge. Instead automates the operations a developer would perform on the local machine after a feature branch had been merged into the default branch remotely, e. g. via Gitlab or Github UI.
# It updates the default branch (which should pull in the merged changes) and deletes the local feature branch.
gm() {
  MAIN_BRANCH=$(git remote show origin | awk '/HEAD branch:/ {print $NF}')
  OLD_BRANCH=$(git symbolic-ref --short HEAD)
  git checkout $MAIN_BRANCH
  gp # another helper that pulls in remote changes
  read -p "Really delete $OLD_BRANCH? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -D $OLD_BRANCH
  else
    git checkout $OLD_BRANCH
    git branch --unset-upstream
    git rebase $MAIN_BRANCH
  fi
}
export -f gm

# 'git rebase'
grb() {
  MAIN_BRANCH=$(git remote show origin | awk '/HEAD branch:/ {print $NF}')
  OLD_BRANCH=$(git symbolic-ref --short HEAD)
  git checkout $MAIN_BRANCH
  gp
  git checkout $OLD_BRANCH
  git rebase $MAIN_BRANCH
}
export -f grb

# 'git delete' (local and remote branch)
gd() {
  CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
  git push origin --delete "${CURRENT_BRANCH}"
  gm
}

# 'git delete local' Only delete local branch
gdl() {
  OLD_BRANCH=$(git symbolic-ref --short HEAD)
  MAIN_BRANCH=$(git remote show origin | awk '/HEAD branch:/ {print $NF}')
  git checkout $MAIN_BRANCH
  git branch -D $OLD_BRANCH
}