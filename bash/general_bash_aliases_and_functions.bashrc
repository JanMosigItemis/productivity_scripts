# common_bash_aliases_and_functions.bashrc
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

# HISTCONTROL controls how commands are saved in the history list.
# ignoreboth: Do not store lines beginning with space sor lines that already have been stored to the history.
HISTCONTROL=ignoreboth

# Force en_US.UTF-8 as terminal language.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8

# Bootstrap ssh-pageant.
# This helps to connect ssh with gpg on Windows systems.
start_ssh_pageant()
{
  eval $(/usr/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")
  export SSH_PAGEANT_PID=$(ps | grep $(which ssh-pageant) | head -n 1 | awk '{print $1}')
}
export -f start_ssh_pageant

# 'Hirn' is German for 'brain'
# Developer's grep. Ignores files and dirs that usually provide a huge amount of false positives, e. g. .git.
# -H .. print file names
# -I .. ignore binary files
# -i .. ignore case
# -r .. also search in all subdirs and their subdirs ('recursive')
# -n .. print line numbers
alias ggrep='grep -HIirn --exclude-dir="*\.git" --exclude-dir="*target" --exclude-dir="*node_modules" --exclude-dir="*\.idea" --exclude-dir="*\.settings" --exclude="*.log.json" --exclude="*package-lock.json" --exclude-dir="*\.npm" --exclude="*swagger-ui*.js*" --exclude-dir="*\.angular" --exclude-dir="*coverage" --exclude-dir="*dist"'

# Like ggrep but matches case.
alias ggrepi='grep -HIrn --exclude-dir="*\.git" --exclude-dir="*target" --exclude-dir="*node_modules" --exclude-dir="*\.idea" --exclude-dir="*\.settings" --exclude="*.log.json" --exclude="*package-lock.json" --exclude-dir="*\.npm" --exclude="*swagger-ui*.js*" --exclude-dir="*\.angular" --exclude-dir="*coverage" --exclude-dir="*dist"'

# 'maven settings'
# Run maven and force the default settings.xml. Also set the user.home system property.
alias mvns="mvn -s ${HOME}/.m2/settings.xml -Duser.home=${HOME}"

# 'mvns clean install'
# Like mvns but forces dependency updates and goals 'clean install'
alias mvnsci='mvns -U clean install'

# 'mvnsci C'
# Like mvnsci but forces concurrent execution of things via threads.
# Uses 1 thread per available CPU core.
alias mvnscic='mvnsci -T 1C'