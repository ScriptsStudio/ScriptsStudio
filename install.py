#!/usr/bin/env python3
import subprocess
import platform
import sys


def plat():
    return platform.system()


def package_oslinux():
    pacman_names = ["apt-get install -y ", "customizer-install ", "flatpak install ", "zypper --non-interactive install -y ", "dnf install -y ", "urpme ", "slackpkg install ", "slapt-get --install ", "netpkg ", "equo install ", "pacman -S ", "eopkg install ", "apk add ", "smart install ", "pkcon install ", "emerge ", "lin ", "cast ", "nix-env -i ", "xbps-install ", "snap install ", "pkg_add -r ", "pkg install " ]
    package_manager_command = pacman_names[0]

    if subprocess.check_output(['uname', '-o']).strip() == b'Android':
        # This expects a path to an .apk file and root (sudo) privileges assuming rooted android device
        if subprocess.check_output(['whoami']).strip() == b'root':
            print("Device is rooted")
            package_manager_command = "pm install "
        else:
            print("Not rooted device")
            package_manager_command = "pkg install "

    return package_manager_command


def package_oswindows():

    pacman_names = ["winget install --accept-package-agreements --accept-source-agreements -h -q ", "choco install -y "]
    package_manager_command = pacman_names[0]
    return package_manager_command


def package_osmac():
    package_manager_command = "brew install "
    return package_manager_command


def process_packagemanager(platf):
    if platf == "Linux":
        return package_oslinux()

    elif platf == "Windows":
        return package_oswindows()

    elif platf == "Darwin":
        return package_osmac()


if __name__ == "__main__":
    
    winget_allowance_command = False
    if plat() == "Windows":
        winget_allowance_command = True

    package_manager_command = process_packagemanager(plat())

    argument_list = sys.argv[1:]
    quer = ""
    final_query = []

    for i in range(len(argument_list)):
        final_query.append(argument_list[i])
        quer += " " + argument_list[i]

    if not winget_allowance_command:
        quer = package_manager_command + quer
    else:
        for i in final_query:
            quer = package_manager_command + " " + i

    subprocess.run(quer, shell=True)