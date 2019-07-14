#!/bin/bash

# test for legit with directories
# legit-*

./legit-init
mkdir b1;
mkdir b2;

# TEST: attempt to add directory to an index
echo "TEST: legit-add directory will not open since its a directory"
./legit-add b1 b2;

