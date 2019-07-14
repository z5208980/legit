#!/bin/bash

# Test the status the stages in legit-rm and adding content into file in the same
#   filename with legit-status. Then showing the content of the files with legit-show
# legit-rm, legit-status, legit-show

./legit-init;
echo file a >a;
echo file b >b;
./legit-add a b;
./legit-commit -m "first commit";
echo "`./legit-status`" | grep "^[ab] - ";     # a - same as repo

# TEST: regular rm deleting for current directory
echo "TEST: legit-status after bash rm(ing) a file";
rm a;
echo "`./legit-status`" | grep "^[ab] - ";     # a - file deleted
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: commiting a deleted a file, (still needs to add change to index)
echo "TEST: legit-commit after bash rm 'a'";
./legit-commit -m "second commit";      # nothing to commit
if [ $? -eq 0 ]; then
    echo "needs to legit-add the deletion of files"; exit 1;
fi

# TEST: checking a deleted file after successdully commit
echo "TEST: legit-add the deletion change to the index";
echo "TEST: legit-commit the deletion successfully";
./legit-add a;
./legit-commit -m "second commit";
echo "`./legit-status`" | grep "^[ab] - ";     # a should not appear since it is deleted and commit

# TEST: create the deleted file and it should act as a new file
echo "TEST: legit-status a newly create file 'a' with same name as the deleted file";
echo file a added again >a;
echo "`./legit-status`" | grep "^[ab] - ";     # a - untracked

# TEST: create the deleted file and it should act as a new file
echo "TEST: legit-add and legit commit successfully the change";
./legit-add a;
echo "TEST: legit-status after legit-add, before legit-commit";
echo "`./legit-status`" | grep "^[ab] - ";     # a - added to index
./legit-commit -m "third commit";
echo "TEST: legit-status after legit-commit";
echo "`./legit-status`" | grep "^[ab] - ";     # a - same as repo

# TEST: show the changes made throughtout the three commit
echo "TEST: legit-show changes in the files with the three commits";
echo "a";
./legit-show 0:a;   # normal
./legit-show 1:a;   # legit-show: error: 'a' not found in commit 1
./legit-show 2:a;   # changed

echo "b";
./legit-show 0:b;   # normal
./legit-show 1:b;   # legit-show: error: 'a' not found in commit 1
./legit-show 2:b;   # changed

rm -rf .legit a b
