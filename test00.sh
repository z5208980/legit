#!/bin/bash
rm -rf .legit;

# Edge cases, argument testing and basic error handling tests
# legit-init, legit-add, legit-commit, legit-log, legit-show

# TEST: when arguments are passed in legit-init
echo "TEST: legit-init with arguments";
./legit-init a b c;     # usage: legit-init
if [ $? -eq 0 ]; then
    echo "./legit should not have any args"; exit 1;
fi

# TEST: check if .legit exist as directory
echo "TEST: legit-init and check for a .legit directory";
./legit-init;   # Initialized empty legit repository in .legit
if [ ! -d '.legit' ]; then
    echo ".legit doesn't exist"; exit 1;
fi

# TEST: ./legit-init twice
echo "TEST: legit-init twice";
./legit-init;   # legit-init: error: .legit already exists
if [ $? -eq 0 ]; then
    echo ".legit already exist and will not make another .legit"; exit 1;
fi

# TEST: add files to index
echo "TEST: legit-add successfully and check exit_status";
echo "line a" > a;
touch b c;
./legit-add a b c;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: adding a file that doesn't exist should print an error message
echo "TEST: legit-add non_existence_file";
./legit-add non_existence_file;  # legit-add: error: can not open 'non_existence_file'
if [ $? -eq 0 ]; then
    echo "cannot add file to index if it doesn't exist"; exit 1;
fi

# TEST: making a commit with '-' at the start of message
echo "TEST: legit-commit with a '-' at start of message";
./legit-commit -m "-1 commit";   # usage: legit-commit [-a] -m commit-message
if [ $? -eq 0 ]; then
    echo "commit shouldn't allow message that start with -"; exit 1;
fi

# TEST: commits without a message but has written a message
echo "TEST: legit-commit without [-m] but with a message";
./legit-commit "first commit";   # usage: legit-commit [-a] -m commit-message
if [ $? -eq 0 ]; then
    echo "cannot commit without -m"; exit 1;
fi

# TEST: commit using the wrong flags
echo "TEST: legit-commit with the wrong flags";
./legit-commit -n "-1 commit";   # usage: legit-commit [-a] -m commit-message
if [ $? -eq 0 ]; then
    echo "cannot commit without -m"; exit 1;
fi

# TEST: commit to a local repo
echo "TEST: legit-commit successfully and checks exit_status";
./legit-commit -m "first commit";   # Committed as commit 0
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: create a second commit straight after, when there is no changes made
echo "TEST: legit-commit twice";
./legit-commit -m "second commit";   # nothing to commit
if [ $? -eq 0 ]; then
    echo "there should be no commit because there is nothing to commit"; exit 1;
fi

# TEST: should only have 1 commit
echo "TEST: legit-log successfully and checks exit_status";
./legit-log;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: show that version that exist
echo "TEST: legit-show the first commit version";
./legit-show 0:a;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: show the first version event without the filenumber
echo "TEST: legit-show the version without adding the commit number [:file]";
./legit-show :a;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: show a version that has been created yet
echo "TEST: legit-show a version that doesn't exist yet";
./legit-show 10:a;  # legit-show: error: unknown commit '10'
if [ $? -eq 0 ]; then
    echo "version 10 in repo doesn't exist yet"; exit 1;
fi

rm -rf "a" "b" "c" ".legit";

# TEST: legit-add, commit, show without initialing with legit-init
echo "TEST: legit-* without legit-init";
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
