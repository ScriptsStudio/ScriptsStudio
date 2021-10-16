#!/usr/bin/env python3
import subprocess
import platform
import sys


def initialize_package_manager_command():
    os_name = platform.system()
    package_manager_command = ""

    # This expects a path to an .apk file and root (sudo) privileges assuming rooted android device
    if subprocess.check_output(['uname', '-o']).strip() == b'Android':
            package_manager_command = "pm install "    
    elif os_name == "Linux":
        pacman_names = ["apt-get install -y ", "customizer-install ", "flatpak install ", "snap install "]
        # This value might vary between flatpak, snapd, apt-get or Linux-Auto-Customizer
        # For the moment expects a valid app name and may need root (sudo) privileges
        package_manager_command = pacman_names[1]
    elif os_name == "Windows":
        package_manager_command = "winget install "
    elif os_name == "Darwin":
        package_manager_command = "brew install "
    else:
        # We assume arch Linux user
        other_pacman_names = ["apt install -y " "pacman install ", "choco install ", "scoop install "]
        package_manager_command = other_pacman_names[1]
    return package_manager_command


if __name__ == "__main__":
    argument_list = sys.argv[1:]
    try:
        quer = initialize_package_manager_command()
        for arg in argument_list:
            arg += " "
            quer += arg
        subprocess.run(quer, shell=True)
    except:
        print("ERROR: Could not launch installation")
        exit(1)