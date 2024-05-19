#!/bin/dash

if [ -d ".pig" ]; then
    rm -rf ".pig"
fi

rm fil*
touch file1
touch file2

echo "Test1: check if correct error is produced when 'pigs-log' is called before 'pigs-init'"
output=$(./pigs-log 2>&1)

if [ "$output" = "pigs-log: error: pigs repository directory .pig not found" ]; then
    echo "Test1 passed: correct error is produced as expected"
else
    echo "Test1 failed: incorrect error is produced.\nexpected 'pigs-log: error: pigs repository directory .pig not found' but your output is $output"
    exit 1
fi

./pigs-init

echo "\nTest2: Correct output for pigs-log"
./pigs-add file1
./pigs-commit -m "first commit"
./pigs-add file2
./pigs-commit -m "second commit"

expected_output="1 second commit
0 first commit"

output=$(./pigs-log)

if [ "$output" = "$expected_output" ]; then
    echo "Test2 passed: correct output for pigs-log"
else
    echo "Test2 failed: incorrect output for pigs-log. \nexpected '$expected_output' but your output is '$output'"
    exit 1
fi
