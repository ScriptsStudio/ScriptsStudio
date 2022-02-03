#!/usr/bin/env python3
import os
import install


def process_hackages(platf):
    if platf == "Linux":
        return ["ssh"]

    elif platf == "Windows":
        pass

    elif platf == "Darwin":
        pass


if __name__ == "__main__":
	hackage_manager = install.process_packagemanager(install.plat())
	tmp = " "
	os.system(hackage_manager + tmp.join(process_hackages(install.plat())))
