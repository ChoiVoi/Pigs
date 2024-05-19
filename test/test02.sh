#!/bin/dash

if [ -d ".pig" ]; then
    rm -r ".pig"
fi

rm file*
touch file1
touch file2

echo "Test1: check if error is produced when calling pigs-add without '.pig' repository created." 

output=$(./pigs-add file1 2>&1)

if [ "$output" = "pigs-add: error: pigs repository directory .pig not found" ]; then
    echo "Test1 passed: error message produced as expected."
else
    echo "Test1 failed: incorrect error message produced.\n expected 'pigs-add: error: pigs repository directory .pig not found' but your output is '$output'"
    exit 1
fi

echo "\nTest2: check if correct error is produced when no file name is provided in the command line argument."

./pigs-init

output=$(./pigs-add 2>&1)

if [ "$output" = "usage: pigs-add <filenames>" ]; then
    echo "Test2 passed: error mesage produced as expected."
else
    echo "Test2 failed: incorrect error message produced.\n expected 'usage: pigs-add <filenames>' but your output is '$output'"
    exit 1
fi

current_branch=$(head -n 1 .pig/branch_list)

echo "\nTest3: check if index directory is created in ',pig' repository."

./pigs-add file1

if [ -d ".pig/branch/$current_branch/index" ]; then
    echo "Test3 passed: index directory is created in '.pig' repository."
else
    echo "Test3 failed: index directory is not created in '.pig' repsitory."
    exit 1
fi

echo "\nTest4: check if non-existent file cannot be added to the index directory."
output=$(./pigs-add non-existent_file 2>&1)

if [ "$output" = "pigs-add: error: can not open 'non-existent_file'" ]; then
    echo "Test4 passed: error message produced as expected"
else
    echo "Test4 failed: incorrect error meassage produced.\n expected 'pigs-add: error: can not open 'non-existent_file'' but your output is '$output'"
    exit 1
fi

echo "\nTest5: check if the file has been added to the index directory"

./pigs-add file2

if [ -f ".pig/branch/$current_branch/index/file2" ]; then
    echo "Test5 passed: File has been added to the index directory."
else    
    echo "Test5 failed: File has not been added to the index directory."
    exit 1
fi

