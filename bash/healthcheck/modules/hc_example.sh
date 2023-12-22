#!/bin/bash
#
# hc_example.sh
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
# hc_example.sh - Example of a healthcheck submodule. See comments for details.
#
# See https://github.com/JanMosigItemis/productivity_scripts
#

# Checking a particular subsystem may involve one or more specific checks.
# Each check shall go into its own function.
# Check is considered successful if the function exits with 0.
# Check is considered failed if the function exits with a result other than 0.

function hc_example_fail() {
  false
}

function hc_example_success() {
  true
}

# If this var is set, the module will be ignored.
# Remove # to deactivate the module.
# module_status="deactivated"
# Will be used to display results.
module_name="This is an example that always fails"
# An array with 2 elements per check function. 1st element is the
# display name of the check. 2nd element is the actual name of the check function.
module_functions=("AlwaysFails" "hc_example_fail" "AlwaysSuccess" "hc_example_success")
