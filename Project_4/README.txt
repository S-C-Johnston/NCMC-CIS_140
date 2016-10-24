The script (Task_One.sh) relies on a single argument, which is a valid username. If the
username argument is not present, or the username is not valid, the script will
return an err and exit.

I included some features to make the script more portable across unixes.

Task_Two.sh is intended to function more as a set of instructions for a user at a tty rather than as a script. The reason for this is that the nature of the specifications for the task involve invoking an interactive program that takes over the current console interface. To demonstrate knowledge, I talk about both ways in which you can suspend a program, both from an interactive interface and remotely assuming you know the PID.

Task_Three.sh is intended to change the format of a phone number string, and replace domain names in email addresses.
