#!/bin/bash
rm -rf .legit;

#
#

./legit-init
echo a >a;
echo b >b;

./legit-add a b;
./legit-commit -m "commit-0";

# Committing a change without first adding to index
echo "TEST: legit-commit file 'a' without adding it to the index";
echo aa >>a;
./legit-commit -m "commit-1";

# Making change to another file and adding the previously changed file to index
echo "TEST: legit-commit 'a' with legit-add, whilst changing 'b' and no legit-add";
echo b >>b;
./legit-add a;
./legit-commit -m "commit-1";

# check that the version in b remains the same and not the change is staged
echo "TEST: legit-show that the a has changed and b remain the same as version 0";
./legit-show 1:a;
./legit-show 1:b;

# trying to delete file using legit-rm
echo "TEST: legit-rm a and b files, if doesn't work then --force";
./legit-rm a;       # should work since its the same as repo
./legit-rm b;       # since file has changed made in curr dir
if [ $? -eq 1 ]; then
    ./legit-rm --force b;       # since file has changed made in curr dir
fi
./legit-status | grep "[ab] - ";     # since a,b was deleted

./legit-commit -m "commit-2 (empty)";
./legit-status | grep "[ab] - ";     # should not appear

# TEST add file back and check status
echo "TEST: legit-status the recreated files that has been recently deleted";
echo a >a;
echo aa >>a;
echo b >b;
./legit-status | grep "[ab] - ";     # should not appear

# TEST add file back and check status
echo "TEST: legit-commit the deleted files that has been created without legit-add";
./legit-commit -m "commit-3 (restore)";

# TEST add file back and check status
echo "TEST: legit-commit the deleted files that has been created with legit-add";
./legit-add a b;
./legit-commit -m "commit-3 (restore)";
./legit-status | grep "[ab] - ";     # should be same as repo again, file are back to tracked
./legit-show 3:a;   # same as the repo with the a, b files
./legit-show 3:b;

rm -rf .legit a b;
