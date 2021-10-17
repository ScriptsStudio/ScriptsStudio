#!/usr/bin/env python3
import subprocess
import platform
import sys


def main():
    argument_list = sys.argv[1:]
    opsy_name = platform.system()
    winget_allowance_command = False
    package_manager_command = ""
    quer = ""
    query_list = []
    final_query = []
    # This expects a path to an .apk file and root (sudo) privileges assuming rooted android device
    if opsy_name == "Linux":
        pacman_names = ["apt-get install -y ", "customizer-install ", "flatpak install ", "zypper --non-interactive install -y ", "dnf install -y ", "urpme ", "slackpkg install ", "slapt-get --install ", "netpkg ", "equo install ", "pacman -S ", "eopkg install ", "apk add ", "smart install ", "pkcon install ", "emerge ", "lin ", "cast ", "nix-env -i ", "xbps-install ", "snap install ", "pkg_add -r ", "pkg install " ]
        # This value might vary between flatpak, snapd, apt-get or Linux-Auto-Customizer
        # For the moment expects a valid app name and may need root (sudo) privileges
        package_manager_command = pacman_names[0]
    elif opsy_name == "Windows":
        package_manager_command = "winget install --accept-package-agreements --accept-source-agreements -h -q "
        winget_allowance_command = True
    elif opsy_name == "Darwin":
        package_manager_command = "brew install "
    else:
        if subprocess.run("uname -o").strip() == 'Android':
            package_manager_command = "pm install "

    for i in range(len(argument_list)):
        final_query.append(argument_list[i])
        quer += " " + argument_list[i]
    # Argument processing (&& in Linux ; in windows)

    if not winget_allowance_command:
        quer = package_manager_command + quer
        subprocess.run(quer, shell=True)
    else:
        #quer += ";"
        # Windows is going to need some logic to install by id performing some research to form the string

        #print(final_query)
        for i in final_query:
            quer = package_manager_command + " " + i
            subprocess.run(quer, shell=True)


if __name__ == "__main__":
    main()
