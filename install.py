#!/usr/bin/env python3
import subprocess
import platform
import sys


def initialize_package_manager_command():
    os_name = platform.system()
    package_manager_command=""
    if subprocess.check_output(['uname', '-o']).strip() == b'Android':
        print("we are in Android")
    elif os_name == "Linux":
        # This value might vary between flatpak, snapd, apt-get or Linux-Auto-Customizer
        package_manager_command="apt-get install -y "
    elif os_name == "Windows":
        package_manager_command="winget install "
    elif os_name == "Darwin":
        package_manager_command="brew install "
    return package_manager_command


if __name__ == "__main__":
    argument_list = sys.argv[1:]
    for arg in argument_list:
        try:
            # Trim '-' and '--' before package name
            if arg[:1] == "-":
                arg = arg[1:]
            if arg[:1] == "-":
                arg = arg[1:]
            subprocess.run(initialize_package_manager_command() + arg, shell=True)
        except:
            print("ERROR: Could not launch installation")
            exit(1)