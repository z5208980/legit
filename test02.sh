#!/bin/bash
rm -rf .legit;

# Edge cases, argument testing and basic error handling tests
# legit-rm, legit-status

# TEST: running legit-rm before legit-init should print an error message
echo "TEST: legit-rm before legit-init";
touch a;
./legit-rm a ;   #  legit-rm: error: no .legit directory containing legit repository exists
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: running legit-status before legit-init should print an error message
echo "TEST: legit-status before legit-init";
./legit-status;     # legit-status: error: no .legit directory containing legit repository exists
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

./legit-init;

# TEST: run legit-status at the start, it should work but output nothing
echo "TEST: legit-status without any commits";
./legit-status;     # legit-status: error: your repository doesn't have any commits yet
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: trying to legit-rm when there is no commits
echo "TEST: legit-rm without any commit";
echo 1 >a;
./legit-add a;
./legit-rm a;       # legit-rm: error: your repository doesn't have any commits yet
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

./legit-commit -m "commit-0";

# TEST: trying to legit-rm an non_existence_file
echo "TEST: legit-rm an non existence file";
./legit-rm non_existence_file;       # legit-rm: error: 'b' is not in the legit repository
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: trying to legit-rm an non_existence_file
echo "TEST: legit-rm --cached an non existence file";
./legit-rm --cached non_existence_file;       # legit-rm: error: 'b' is not in the legit repository
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: trying to legit-rm an non_existence_file
echo "TEST: legit-rm --force an non existence file";
./legit-rm --force non_existence_file;       # legit-rm: error: 'b' is not in the legit repository
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: test with wrongs flags
echo "TEST: legit-rm wrong flags";
./legit-rm --cache a;       # legit-rm: error: 'b' is not in the legit repository
if [ $? -eq 0 ]; then
    echo "didn't exit successfully"; exit 1;
fi

# TEST: trying to legit-rm an non_existence_file
echo "TEST: legit-rm successfully after a commit";
./legit-rm a;
echo "`./legit-status`" | grep "^a - ";     # a - deleted

rm -rf .legit a;
