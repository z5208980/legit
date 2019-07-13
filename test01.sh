#!/bin/bash
rm -rf .legit;

# add + commit + comparing logs and repo to the expected results
# legit-add, legit-commit, legit-log, legit-show

echo "TEST: legit add, commit 10 times and
        check logs and compare file versions for each commit";
./legit-init;
echo a > a;
echo b > b;
echo c > c;
./legit-add a b c;
./legit-commit -m "commit-0";
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi
echo "0 commit-0" > tmp.txt;
./legit-log > log.txt;
if [ $? -eq 1 ]; then
    echo "didn't exit successfully"; exit 1;
fi
echo "TEST: legit-log: comparing commit '0' logs";
if ! cmp log.txt tmp.txt; then
    echo "lastest repo doesn't match the master branch"; exit 1;
fi

# TEST: make 10 commit to a whilst remaining files are kept the same
for i in {1..10}
do
    echo aa >> a;
    ./legit-add a;
    ./legit-commit -m "commit-$i";
    if [ $? -eq 1 ]; then
        echo "didn't exit successfully"; exit 1;
    fi

    echo "TEST: legit-log: comparing commit '$i' logs";
    ./legit-log > log.txt;
    echo "$i commit-$i" >> tmp.txt;
    sort -nr tmp.txt > log_cmp.txt;
    if ! cmp log_cmp.txt log.txt; then
        echo "lastest repo doesn't match the master branch"; exit 1;
    fi
done
rm log.txt log_cmp.txt tmp.txt;

# TEST: check if the lastest repo is upto date with the current directory
for i in a b c
do
    echo "TEST: legit-show: comparing '$i' in current directory with the latest repo";
    ./legit-show 10:$i > tmp.txt;
    if [ $? -eq 1 ]; then
        echo "didn't exit successfully"; exit 1;
    fi
    if ! cmp $i tmp.txt; then
        echo "lastest repo doesn't match the master branch"; exit 1;
    fi
done

rm -rf .legit tmp.txt a b c;
