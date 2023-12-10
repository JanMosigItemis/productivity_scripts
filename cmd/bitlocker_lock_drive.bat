REM bitlocker_lock_drive.bat
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

REM Lock a decrypted drive with Bitlocker.
REM Usage: bitlocker_lock_drive.bat "<drive_letter>:"
REM Example: bitlocker_lock_drive.bat "d:"

REM The ~ removes any surrounding quotes.
if "%~1"=="" (
  echo Missing drive letter argument
  goto :end
)

set drive_letter=%1
set drive_letter=%drive_letter:"=%
manage-bde -lock "%drive_letter%" -ForceDismount
:end