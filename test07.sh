#!/bin/bash
rm -rf .legit;
#
#

./legit-init
for i in a b c d e f
do
    echo $i >$i;
done
./legit-add a b c d e;
./legit-commit -m "commit-0";

./legit-add f;
./legit-commit -m "commit-0";
./legit-status;

./legit-rm a --cached;
