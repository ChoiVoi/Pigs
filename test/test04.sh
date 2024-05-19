#!/bin/dash

if [ -d ".pig" ]; then
    rm -r ".pig"
fi

rm file*

touch file1
touch file2
touch file3
./pigs-init


echo "Test1: correct output when commiting file"
./pigs-add file1
output=$(./pigs-commit -m "first commit" 2>&1)

if [ "$output" = "Committed as commit 0" ]; then
    echo "Test1 passed: correct output is produced"
else
    echo "Test1 failed: incorrect output is produecd.\nexpected output is 'Commited as commit 0' but your output is '$output'"
    exit 1
fi

echo "\nTest2: correct output when comitting file before adding it to the index directory"

current_branch=$(head -n 1 .pig/branch_list)
if [ -f ".pig/branch/$current_branch/index//* " ]; then
    rm ".pig/branch/$current_branch/index/"*
fi
output=$(./pigs-commit -m "commit with no filed added to the index")

if [ "$output" = "nothing to commit" ]; then
    echo "Test2 passed: correct output is produced."
else    
    echo "Test2 failed: incorrect output is produced.\nexpected 'nothing to commit' but your output is $output"
    exit 1
fi

echo "\nTest3: correct output when committing file which the content in the file has not been changed after being committed before."
touch file4
./pigs-add file4
./pigs-commit -m "commit"
./pigs-add file4
output=$(./pigs-commit -m "commit with no change" 2>&1)

if [ "$output" = "nothing to commit" ]; then
    echo "Test3 passed: correct output is produced."
else
    echo "Test3 passed: incorrect output is produced.\nexpected 'nothing to commit' but your output is $output"
    exit 1
fi

