##Author: Stewart Johnston
##Title: Quiz1
##Purpose: Demonstrate understanding of directory and plaintext manipulation commands.
##Revision: 2019-10-17

mkdir -p test/red/magenta/ test/blue/cyan
echo 'echo "This file is in folder $(/usr/bin/env readlink -nf ${0} | rev | cut -d/ -f 2 | rev)"' | tee test/red/red.bsh test/blue/blue.bsh test/red/magenta/magenta.bsh > test/blue/cyan/cyan.bsh
find test -type f -name *.bsh -exec chmod +x {} \;
find test -type f -name *.bsh -exec cat {} >> test/scripts \;
find test -mindepth 1 \! -name *next -type d -exec mkdir {}/next \;
find test \! -iwholename *next* -a -type f -name *.bsh -execdir cp {} ./next/ \;
find test -type f -iwholename *next/*.bsh -execdir rename .bsh next.bsh {} \;
#so, I didn't realize right away that Fedora-distros have a different `rename`
#util than Debian-distros. Was using a regex, now using properly.
echo "ls -R $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" \
>> test/contents;
#http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
chmod +x test/contents
grep -wn 'folder' $(find test/ -type f \! -name foundText) > test/foundText
#rm -rf test/{red,blue}
