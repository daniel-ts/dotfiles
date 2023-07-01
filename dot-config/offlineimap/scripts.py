#! /usr/bin/env python
import os
import subprocess as sub

def kp_get_pass(account):
    return sub.check_output("secret-tool lookup Title " + account, shell=True).splitlines()[0].decode("UTF-8")

def kp_get_username(account):
    return sub.run(["secret-tool", "search", "--unlock", "Title", account], capture_output=True).stderr.splitlines()[2].decode("UTF-8").split(" = ")[1]
