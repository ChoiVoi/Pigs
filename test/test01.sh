#!/bin/dash

if [ -d ".pig" ]; then
    rm -r ".pig"
fi

echo "Test1: check if pigs-init produces correct output"
output=$(./pigs-init 2>&1)

if [ "$output" = "Initialized empty pigs repository in .pig" ]; then
    echo "Test1 passed: correct output produced as expected."
else
    echo "Test1 failed: incorrect output produced.\n expected 'Initialized empty pigs repository in .pig' but your output is $output"
    exit 1
fi 

echo "\nTest2: check if '.pig' is created"
if [ -d ".pig" ]; then
    echo "Test2 passed: '.pig' direcotry is created"
else
    echo "Test2 failed: '.pig' directory is not created."
    exit 1
fi

echo "\nTest3: check if pigs-init produces correct error if pigs-init is called twice"

output=$(./pigs-init 2>&1)

if [ "$output" = "pigs-init: error: .pig already exists" ]; then
    echo "Test3 passed: error message produced as expected."
else
    echo "Test3 failed: incorrect error message message produced.\n expected 'Test1 passed: error message produced as expected' but your output is $output"
    exit 1
fi 