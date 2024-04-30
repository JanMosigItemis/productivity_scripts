REM init_gpg.bat
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

REM A script that helps reloading gpg smart card services.
REM Helps with (re)recognizing a 'stuck' smartcard in case 'gpg --card-status' returns "No such device" or "IPC error" when smartcards have been switched.
REM See https://www.gpg4win.de for details on involved services and commands.

@ECHO OFF

gpgconf --kill gpg-agent & timeout 1 & gpgconf --kill scdaemon & timeout 1 & taskkill /IM "scdaemon.exe" /F & taskkill /IM "gpg-agent.exe" /F & timeout 5 & gpgconf --reload gpg-agent & timeout 1 & gpgconf --reload scdaemon & timeout 1 & gpg --card-status && timeout 2
