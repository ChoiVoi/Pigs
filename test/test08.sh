#!/bin/dash

if [ -d ".pig" ]; then
    rm -rf ".pig"
fi

rm fil*

./pigs-init
touch file1
echo "file1" >> file1
current_branch=$(head -n 1 .pig/branch_list)

echo "Test1: check if correct error is produced when 'pigs-commit -a -m' is called before adding the file in the index"
output=$(./pigs-commit -a -m "commit" 2>&1)

if [ "$output" = "nothing to commit" ]; then
    echo "Test1 passed: correct error message is produced"
else
    echo "test1 failed: incorrect error message is produced.\nexpected output is 'nothing to commit' but your output is '$output'"
    exit 1
fi


echo "\nTest2: check if the file has been added to the commit after 'pigs-commit -a -m'"

./pigs-add file1
echo "file1 modified." >> file1
./pigs-commit -a -m "add and commit"

if [ -f ".pig/branch/$current_branch/commit/0/file1" ]; then
    echo "Test2 passed: File has been added to commit"
else    
    echo "Test2 failed: File has not been added to commit"
    exit 1
fi
