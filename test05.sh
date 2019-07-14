#!/bin/bash
rm -rf .legit;
#
#

./legit-init
echo hello >a;
echo hello >b;

./legit-add a b;
./legit-commit -m "first commit";

echo world >>a;
./legit-commit -m "second commit";
