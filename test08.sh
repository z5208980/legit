#!/bin/bash
rm -rf .legit;

# test all the successfully legit-rm cases 
# legit-rm

./legit-init;
echo a >a;                                                                   
echo b >b;
echo c >c;
echo d >d;
./legit-add a b c d;
./legit-commit -m "commit-0";

# TEST:
echo "TEST: legit-rm all the possible commands with and without flags";
./legit-rm a;                   # remove a from curr dir
./legit-rm --cached b;          # remove b from index only
./legit-rm --force c;           # remove the up to date c
./legit-rm --cached --force d;  # remove c

# TEST: legit-rm files again to see if they delete files
echo "TEST: legit-rm twice to check if it rm from current directory";
./legit-rm a;                  
./legit-rm b;          
./legit-rm c;          
./legit-rm d;  

# TEST: commit and check for files in repo
echo "TEST: legit-commit to show the status of repr with legit-show";
# only b d exist in curr, nothing in index
./legit-commit -m "commit-1";   # a and d shouldn't not show in status
./legit-show 1:a;
./legit-show 1:b;
./legit-show 1:c;
./legit-show 1:d;

rm -rf .legit a b c d;
