#!/bin/bash
rm -rf .legit;

#
#

./legit-init;
echo a >a;
echo b >b;
echo c >c;
echo d >d;
echo e >e;
./legit-add a b c d e;
./legit-rm --cached a;
./legit-rm --cached b;
./legit-rm --cached c;
./legit-rm --cached d;
./legit-rm --cached e;
./legit-commit -m "commit-0";

./legit-status;
