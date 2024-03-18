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

# Functions in this file are using a sub shell in order for set -e to be restricted to the runtime of each function only.
# Sub shell is opened with 'func_name{( set -e ; commands )}' instead of 'func_name{ commands }'.
# See https://unix.stackexchange.com/a/721798

main_branch() {
  echo $(git remote show origin | awk '/HEAD branch:/ {print $NF}')
}

current_branch() {
  echo $(git symbolic-ref --short HEAD)
}

# 'force push'
# Overwrite the last commit and force push it. 
# Can be used to update the last commit instead of committing every little piece of work with a separate commit.
# THIS IS A DANGEROUS OPERATION! It does not store incremental changes on purpose, i. e. you can't revert change 7 of 10. Use with care!
fp() {(
  set -e
  git add -A
  git commit --amend --no-edit
  read -p "Really force push? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin -f
  fi
  echo "Last update: $(date +"%Y-%m-%d %H:%M:%S%z")"
)}
export -f fp

# 'git merge'
# Does NOT perform a merge. Instead automates the operations a developer would perform on the local machine after a feature branch had been merged into the default branch remotely, e. g. via Gitlab or Github UI.
# Checkout branch $1 or the main branch of the repo if $1 is not given. Update it and merge in all changes from the current branch. Then delete the current branch.
gm() {(
  set -e
  if [ -z "$1" ]; then MAIN_BRANCH=$(main_branch) ; else MAIN_BRANCH="$1" ; fi
  OLD_BRANCH=$(current_branch)
  git checkout $MAIN_BRANCH
  gp # another helper that pulls in remote changes
  read -p "Really delete $OLD_BRANCH? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -D $OLD_BRANCH
  fi
)}
export -f gm

# 'git rebase'
# Checkout branch $1 or the main branch of the repo if $1 is not given. Update it and rebase the current branch onto it.
grb() {(
  set -e
  if [ -z "$1" ]; then MAIN_BRANCH=$(main_branch) ; else MAIN_BRANCH="$1" ; fi
  echo "Rebasing on ${MAIN_BRANCH}"
  OLD_BRANCH=$(current_branch)
  git checkout $MAIN_BRANCH
  gp
  git checkout $OLD_BRANCH
  git rebase $MAIN_BRANCH
)}
export -f grb

# 'git delete' current local branch and remote branch with the same name. Then checkout main branch.
gd() {(
  set -e
  CURRENT_BRANCH=$(current_branch)
  # Do not fail if the branch happens to already be gone.
  set +e
  git push origin --delete "${CURRENT_BRANCH}"
  set -e
  gm
)}

# 'git delete local' Only delete current local branch. Then checkout main branch.
gdl() {
  MAIN_BRANCH=$(main_branch)
  OLD_BRANCH=$(current_branch)
  git checkout $MAIN_BRANCH
  git branch -D $OLD_BRANCH
}

# 'git pull'
# Fetch all remote changes for all branches.
# Merge them into the current branch.
# Also fetch all remote tags and override local tags of the same name.
alias gp='git fetch -p --tags --force && git pull --rebase=false'

# 'git pull rebase'
# Fetch all remote changes for all branches.
# Rebase the current branch onto the remote changes.
# Also fetch all remote tags and override local tags of the same name.
alias gpr='git fetch -p --tags --force && git pull --rebase=true'

# 'git status'
alias gs='git status'

# 'last commit'
# Display contents of last commit. Also supports merge commits.
alias lc='git diff-tree --no-commit-id --name-only -r -m -c --cc HEAD'

# 'git log'
# Pretty print last 3 commits.
alias gl='git log -3 --pretty=fuller'

# 'git log log'
# Pretty print last 7 commits. The more commits are displayed, the more likely it gets that results need to be paged with less.
alias gll='git log -7 --pretty=fuller'

# Unstage last commit.
alias ulc='git log -1 --pretty=%B && git reset --soft HEAD~1'
