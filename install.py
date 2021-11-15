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

    if opsy_name == "Linux":
        pacman_names = ["apt-get install -y ", "customizer-install", "flatpak install ", "zypper --non-interactive install -y ", "dnf install -y ", "urpme ", "slackpkg install ", "slapt-get --install ", "netpkg ", "equo install ", "pacman -S ", "eopkg install ", "apk add ", "smart install ", "pkcon install ", "emerge ", "lin ", "cast ", "nix-env -i ", "xbps-install ", "snap install ", "pkg_add -r ", "pkg install " ]
        package_manager_command = pacman_names[0]
        android_quer = "sudo whoami"
        if subprocess.check_output(['uname', '-o']).strip() == b'Android':
            # This expects a path to an .apk file and root (sudo) privileges assuming rooted android device
            if subprocess.check_output(['whoami']).strip() == b'root':
                print("Device is rooted")
                package_manager_command = "pm install "
            else:
                print("Not rooted device")
                package_manager_command = "pkg install "

    elif opsy_name == "Windows":
        pacman_names = ["winget install --accept-package-agreements --accept-source-agreements -h -q ", "choco install -y "]
        package_manager_command = pacman_names[0]
        winget_allowance_command = True
    elif opsy_name == "Darwin":
        package_manager_command = "brew install "
    else:
        pass

    for i in range(len(argument_list)):
        final_query.append(argument_list[i])
        quer += " " + argument_list[i]


    if not winget_allowance_command:
        quer = package_manager_command + quer
        subprocess.run(quer, shell=True)
    else:
        for i in final_query:
            quer = package_manager_command + " " + i
            subprocess.run(quer, shell=True)


if __name__ == "__main__":
    main()
