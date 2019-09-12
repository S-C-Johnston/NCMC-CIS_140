#!/usr/bin/env bash
/home/links & #Start in background
sleep 60; sleep 60; ls -alR / > flist &
fg #fg w/ no args foregrounds the most recently background-ed job

##From within links:
#ctrl-z
##ctrl-z passes the metacharacter to whatever process is in the foreground that suspends it and puts it in the background

##Suspending from outside a program:
#kill -19 (JOB||PID)
##kill -19 sends the suspend signal to the argument-defined processes

pkill -9 -n -f -u ${EUID} "/home/links" #sends SIGKILL (-9) to the newest (-n) process that matches "/home/links" somewhere in its details (-f) and belongs to the user who called this script (-u ${EUID}

jobs #prints the jobspec, name, and status of all jobs currently running from the current console
