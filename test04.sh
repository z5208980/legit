#!/bin/bash

# Test errors that will occurs in legit-rm and how to solve them
# legit-rm, legit-show

./legit-init;
k=0;
for i in a b c d e f g h
do
    echo $k > $i;
    k=`expr $k + 1`;
done

./legit-add a b c
./legit-commit -m "a b c commit";
for i in a b c
do
    echo "$i: `./legit-show 0:$i`";
done

./legit-status > /dev/null 2>&1;
./legit-rm a;

# TEST: legit-rm,  --cached and --force with give err since legit-rm a previously
#           removed file from index
echo "TEST: legit-rm with --cached and --force twice will give error msg";
./legit-rm a;
./legit-rm --cached a;  # legit-rm: error: 'a' is not in the legit repository
./legit-rm --force a;   # legit-rm: error: 'a' is not in the legit repository

# TEST: make change to committed file and remove
echo "TEST: legit-rm deleting that has been modified and is different to the repo";
echo b >b;
./legit-rm b;   # legit-rm: error: 'b' in repository is different to working file

./legit-add b;
./legit-commit -m "a(deleted) b(change) c(repo) commit";
for i in a b c
do
    echo "$i: `./legit-show 1:$i`";
done

# TEST: deleting a file that has never been committed will give error.
#           as for the multiple arguments, it will only exit with the first
#           file as there is already an error
echo "TEST: legit-rm files that has never been committed to a repo"
echo "TEST: legit-rm with multiple file arguments"
./legit-rm d e f g h;   # legit-rm: error: '[d]' is not in the legit repository

# TEST: successfully deleting multiple files in one cmd and commiting the change
echo "TEST: legit-rm successfully with multiple file arguments [d e f g h]"
./legit-add d e f g h;   # legit-rm: error: '[d]' is not in the legit repository
./legit-commit -m "b(same) c(same) d e f g h commit";
for i in a b c d e f g h
do
    echo "$i: `./legit-show 2:$i`";
done
./legit-rm d e f g h;   # legit-rm: error: '[d]' is not in the legit repository
./legit-commit -m "b(same) c(same) [d e f g h](delete) commit";

for i in a b c d e f g h
do
    echo "$i: `./legit-show 3:$i`";
done

# TEST: deleting file with --cached make file untracked on next commits
echo "TEST: legit-rm --cached successfully";
./legit-rm --cached b;
./legit-commit -m "a(deleted) b(deleted) c(repo) commit";
./legit-show 2:a;
./legit-show 2:b;
./legit-show 2:c;

# TEST: legit-rm --force multiple files will result in exiting to strerr with the
#           first file in argument
echo "TEST: legit-rm a file that has never been committed to a repo"
echo "TEST: legit-rm with multiple file arguments"
./legit-rm --force g h;   # legit-rm: error: '[gh]' is not in the legit repository

rm -rf .legit a b c d e f g h;
