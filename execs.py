import os

pid = os.fork()
if pid == 0:
    os.execv()
