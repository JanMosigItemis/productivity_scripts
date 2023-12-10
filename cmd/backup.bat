REM backup.bat
REM Copyright (C) 2023  Jan Mosig

REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM any later version.

REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.

REM You should have received a copy of the GNU General Public License
REM along with this program.  If not, see <http://www.gnu.org/licenses/>.

REM https://github.com/JanMosigItemis/productivity_scripts

@ECHO OFF
SETLOCAL

REM Use rsync to make a full backup of a drive to another drive.
REM Script was originally written to collect all rsync options necessary to rsync from a e4fs (Linux) based network drive to a vfat based mobile backup drive via network.
REM example usage: backup d: e:

if "%~1"=="" (
  echo Missing src argument
  goto :end
)
if "%~2"=="" (
  echo Missing dest argument
  goto :end
)

set src_drive="%1"
set src_drive=%src_drive:"=%
set dest_drive="%2"
set dest_drive=%dest_drive:"=%
echo rsyncing from %src_drive% to %dest_drive%

set src_drive=%src_drive::=%
cd %dest_drive%
REM Tested with cwRsync
REM -W .. copy whole files instead of calculating incremental diffs. Tends to be faster this way if one of the provided drives is a network share.
REM -h .. human readable numbers
REM -a .. archive mode, i. e. recursion + preserve everything
REM -v .. increased verbosity
REM -z .. compress file data during transfer
REM --size-only .. skip files that match in size. This is faster but also kind of dangerous and thus disabled by default.
REM --info=progress2 .. My personal progress display flavor
REM --delete-during .. Delete files during transfer. Tends to make things a bit faster.
REM --delete-excluded .. Also delete excluded files on dest
REM --exclude-from .. Exclude patterns from file
rsync -Whavz --stats --info=progress2 --delete-during --delete-excluded --exclude-from="rsync.excludes" "/cygdrive/%src_drive%/" ./

:end
