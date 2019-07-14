#!/bin/bash
rm -rf .legit;

# test legit commands that have flags attached. checks if they still commit 
#       or remove files if they are provide with usual arguments that do not
#       match their usage.
# legit-commit, legit-rm

./legit-init
for i in a b c d e f g h i j k
do
    echo $i >$i;

done
./legit-add a b c d e f g h i j k;

# TEST: commit using wrong arugument locations
echo "TEST: legit-commit but commit message is first followed by '-m'";
./legit-commit "commit-0" -m;

# TEST: commit with more than one commit message
echo "TEST: legit-commit but more than one commit message";
./legit-commit -m "commit-0" "commit-1";

# TEST: commit with -a and wrong argument location
echo "TEST: legit-commit -a with commit message followed by -m";
./legit-commit -a "commit-0";
./legit-commit -a "commit-0" -m;

# TEST: commit with -a and more than one message
echo "TEST: legit-commit -a but more than one commit message";
./legit-commit -a "commit-0" -m "commit-1";

./legit-commit -m "commit-0";

./legit-add f;
./legit-commit -m "commit-1";
./legit-status | grep "^[abcdefghijk] - ";

# TEST: removing file using legit-rm and have files first then the flags
echo "TEST: legit-rm but files first then --cached --force";
./legit-rm a --cached;
./legit-rm b --force;
./legit-rm c --cached --force;

./legit-commit -m "commit-2";
./legit-status | grep "^[abcdefghijk] - ";

# TEST: removing file using legit-rm and have files first then the flags pt 2
echo "TEST: legit-rm but the arguments are randomised";
./legit-rm d --cached e;
./legit-rm f --force g;
./legit-rm h --cached i --force j k;
./legit-status | grep "^[abcdefghijk] - ";


rm -rf .legit a b c d e f g h i j k;
