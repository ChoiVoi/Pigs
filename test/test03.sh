#!/bin/dash

if [ -d ".pig" ]; then
    rm -rf ".pig"
fi

rm fil*

touch file1

echo "\nTest1: check if the correct output is produced when pigs-commiit command is called before pigs-init is"
output=$(./pigs-commit -m file1 2>&1)

if [ "$output" =  "./pigs-commit: error: .pig directory not found" ]; then
    echo "Test1 passed: error message produced as expected."
else
    echo "Test1 failed: incorrect error message produced.\n expected  './pigs-commit: error: .pig directory not found' but your output is $output"
    exit 1
fi

echo "\n"
./pigs-init

echo "\nTest2: check if the correct output is produced when there is no either '-m' or '-a' option in 'pigs-commit'"
output1=$(./pigs-commit file1 2>&1)

if [ "$output1" = "usage: pigs-commit [-a] -m commit-message" ]; then
    echo "Test2_1 passed: error message produced as expected."
else
    echo "Test2_1 failed: incorrect error message produced.\n expected 'usage: pigs-commit [-a] -m commit-message' but your output is $output1"
    exit 1
fi

output2=$(./pigs-commit -x file1 2>&1)
if [ "$output2" = "usage: pigs-commit [-a] -m commit-message" ]; then
    echo "Test2_2 passed: error message produced as expected."
else
    echo "Test2_2 failed: incorrect error message produced.\n expected 'usage: pigs-commit [-a] -m commit-message' but your output is $output2"
    exit 1
fi

echo "\nTest3: check if the correct output is produced when there is no delete-list and index directory is clear."
output=$(./pigs-commit -m file1 2>&1)
if [ "$output" = "nothing to commit" ]; then
    echo "Test3 passed: correct output is produced."
else    
    echo "Test3 failed: incorrect output is produced.\n expected 'nothing to commit' but your output is '$output'."
    exit 1
fi