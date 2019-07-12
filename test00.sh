#!/bin/bash

# Edge cases, argument testing and basic error handling tests

# TEST: when arguments are passed in legit-init
./legit-init a b c;     # usage: legit-init
if [ $? -eq 0 ]; then
    echo "./legit should not have any args"; exit 1;
fi

# TEST: check if .legit exist as directory
./legit-init;   # Initialized empty legit repository in .legit
if [ ! -d '.legit' ]; then
    echo ".legit doesn't exist"; exit 1;
fi

# TEST: should print to stdout ".legit already exists" with exit 1
./legit-init;   # legit-init: error: .legit already exists
if [ $? -eq 0 ]; then
    echo ".legit already exist and will not make another .legit"; exit 1;
fi

# TEST: add files to index
echo "line a" > a;
touch b c;
./legit-add a b c;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: adding a file that doesn't exist should print an error message
./legit-add d;  # legit-add: error: can not open 'd'
if [ $? -eq 0 ]; then
    echo "cannot add file to index if it doesn't exist"; exit 1;
fi

# TEST: create a second commit straight after, when there is no changes made
./legit-commit -m "-1 commit";   # usage: legit-commit [-a] -m commit-message
if [ $? -eq 0 ]; then
    echo "commit shouldn't allow message that start with -"; exit 1;
fi

# TEST: commits without a message but has written a message
./legit-commit "-1 commit";   # usage: legit-commit [-a] -m commit-message
if [ $? -eq 0 ]; then
    echo "cannot commit without -m"; exit 1;
fi

# TEST: commit using the wrong flags
./legit-commit -n "-1 commit";   # usage: legit-commit [-a] -m commit-message
if [ $? -eq 0 ]; then
    echo "cannot commit without -m"; exit 1;
fi

# TEST: commit to a local repo
./legit-commit -m "first commit";   # Committed as commit 0
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: create a second commit straight after, when there is no changes made
./legit-commit -m "second commit";   # nothing to commit
if [ $? -eq 0 ]; then
    echo "there should be no commit because there is nothing to commit"; exit 1;
fi

# TEST: should only have 1 commit
./legit-log;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: show that version that exist
./legit-show 0:a;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: show the first version event without the filenumber
./legit-show :a;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: show a version that has been created yet
./legit-show 10:a;  # legit-show: error: unknown commit '10'
if [ $? -eq 0 ]; then
    echo "version 10 of master doesn't exist yet"; exit 1;
fi

rm -rf "a" "b" "c" ".legit";

# TEST: legit-add, commit, show without initialing with legit-init
touch a;
./legit-add a;  # legit-add: error: no .legit directory containing legit repository exists no commits
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi
./legit-commit -m "first commit";
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi
./legit-log;
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi
./legit-show;   # legit-show: error: unknown commit ''
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

rm -rf "a";
