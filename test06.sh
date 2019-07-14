#!/bin/bash
rm -rf .legit;

# test to see what happens in early stages of legit-rm before a commit. Also
#       attempt to pop files of repos but maintaining current directory
# legit-rm --cached, legit-commit

./legit-init;
for i in a b c d e f
do
    echo $i >$i;
done
./legit-add a b c d e;

# TEST: undo the legit-add
echo "TEST: legit-rm the entire index and commit";
for i in a b c d e
do
    ./legit-rm --cached $i;
done
./legit-commit -m "commit-0";
./legit-status | grep "^[abcdef] - ";

# TEST: legit-show to show there is nothing inside committed repo
echo "TEST: legit-show the committed repo";
for i in a b c d e
do
    ./legit-show 0:$i;
done

# TEST: popping file one by one by legit-rm and commiting changes to latest deletion
./legit-add a b c d e f;

count=1;
for j in a b c d e f
do
    echo "TEST: removing file $j from latest repo"
    ./legit-rm --cached $j;
    ./legit-commit -m "commit-$count $j deleted";
    for i in a b c d e f
    do
        ./legit-show $count:$i;
    done

    count=`expr $count + 1`;
done
./legit-status | grep "^[abcdef] - ";

rm -rf .legit a b c d e f;
