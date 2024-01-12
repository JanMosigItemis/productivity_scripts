# Productivity Shell Scripts
Various little shell scripts that I use on a daily basis.

Scripts, commands and aliases are documented within their respective script files. Names are very short on purpose to make memorizing easier and typing faster.

## Content Overview

### Bash

#### Git Scripts

|||
|---|---|
| pp.sh | Update all repositories within the current working dir. |

#### Git Aliases

|||
|---|---|
| fp | Force push all current changes |
| gm | Delete current branch, change to default branch and pull in latest changes |
| grb | rebase current branch onto default branch |
| gd | Delete current branch (local **and** remote) and change to default branch |
| gdl | Like `gd` but does not delete remote branch |
| gp | Fetch all remote changes and tags. Update current branch. |
| gs | [git status](https://git-scm.com/docs/git-status) |
| lc | Show contents of last commit |
| gl | Show last 3 commits |
| gll | Show last 7 commits |
| ulc | Unstage last commit |

#### General Scripts

|||
|---|---|
| build.sh | Build all Maven projects in current working dir |
| lib.sh   | Helper library that many of my scripts depend on |
| pu.sh    | apt-based package update script |
| healthcheck.sh | Modularized system helthcheck |

#### General Aliases

|||
|---|---|
| ggrep | `grep -Hirn` with a couple of software development related exclusions |
| ggrepi | Same as ggrep but case **i**nsensitive |
| mvns | Run Maven with your custom settings.xml and home dir |
| mvnsci | Run mvns with goals `clean install` |
| mvnscic | Same as mvnsci but with options `-T 1C` (parallelize build) |
| start_ssh_pageant | See [Blog](https://blogs.itemis.com/en/openpgp-on-the-job-part-8-ssh-with-openpgp-and-yubikey) |

### Windows Command Prompt (cmd.exe)

|||
|---|---|
| backup.bat | Backup a network drive to a hard drive via rsync. Tested with [cwRsync](https://itefix.net/cwrsync) |
| bitlocker_lock_drive.bat | Lock an "opened" drive with BitLocker |
| init_gpg.bat | A heuristic approach on reloading the gpg4win services |
| reset_network.bat | Flush DNS and renew DHCP leases |

### Windows Power Shell

|||
|---|---|
| change_dns_to_cloudflare.ps1 | Change IPv4 and IPv6 DNS servers to [Cloudflare](https://www.cloudflare.com/learning/dns/what-is-1.1.1.1) |
| change_dns_to_dhcp.ps1 | Reset DNS settings to use whatever your local DHCP provides |
| eject.ps1 | Eject the disc of the first optical drive registered to the OS |



