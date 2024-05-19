#!/bin/dash

if [ -d ".pig" ]; then
    rm -rf ".pig"
fi

rm fil*
touch file1
touch file2
touch file3
echo "first file" >> file1
echo "second file" >> file2


echo "Test1: correct error message when 'pigs-show' is called before 'pigs-init'"
output=$(./pigs-show 2>&1)

if [ "$output" = "pigs-show: error: pigs repository directory .pig not found" ]; then 
    echo "Test1 passed: correct error message produced as expected."
else
    echo "Test1 failed: incorrect error message produced.\nexpected 'pigs-show: error: pigs repository directory .pig not found' but your output is '$output'"
    exit 1
fi

echo "\nTest2: correct error message when 'pigs-show' is called without argument"

./pigs-init
output=$(./pigs-show 2>&1)

if [ "$output" = "usage: pigs-show <commit>:<filename>" ]; then
    echo "Test2 passed: correct error message produced as expected."
else
    echo "Test2 failed: incorrect error message produced.\nexpected 'usage: pigs-show <commit>:<filename>' but your output is '$output'"
    exit 1
fi

echo "\nTest3: correct error message when 'pigs-show' is called with argment which does not contain ':'"
output=$(./pigs-show file1 2>&1)

if [ "$output" = "usage: pigs-show <commit>:<filename>" ]; then
    echo "Test3 passed: correct error message produced as expected."
else
    echo "Test3 failed: incorrect error message produced.\nexpected 'usage: pigs-show <commit>:<filename>' but your output is '$output'"
    exit 1
fi

echo "\nTest4: correct error messsage when 'pigs-show' is called but the file is not in the index"
output=$(./pigs-show :file1 2>&1)

if [ "$output" = "pigs-show: error: 'file1' not found in index" ]; then
    echo "Test4 passed: correct error message produced as expected."
else
    echo "Test4 failed: incorrect error message produced.\nexpected 'pigs-show: error: 'file1' not found in index' but your output is '$output'"
    exit 1
fi

echo "\nTest5: correct error message when 'pigs-show' is called with unkonw commit"
./pigs-add file1
./pigs-add file2
./pigs-commit -m "first commit"
output=$(./pigs-show 5:file1 2>&1)

if [ "$output" = "pigs-show: error: unknown commit '5'" ]; then
    echo "Test5 passed: correct error message produced as expected."
else
    echo "Test5 failed: incorrect error message produced.\nexpected 'pigs-show: error: unknown commit '5'' but your output is '$output'"
    exit 1
fi

echo "\nTest6: correct error message when 'pigs-show' is called with unkonwn commit"
output=$(./pigs-show 0:file3 2>&1)

if [ "$output" = "pigs-show: error: 'file3' not found in commit 0" ]; then
    echo "Test6 passed: correct error message produced as expected."
else
    echo "Test6 failed: incorrect error message produced.\nexpected 'pigs-show: error: 'file3' not found in commit 0' but your output is '$output'"
    exit 1
fi

echo "\nTest7: correct output for pigs-show with commit number"
output=$(./pigs-show 0:file1 2>&1)

if [ "$output" = "first file" ]; then
    echo "Test7 passed: correct output for pigs-show"
else
    echo "Test7 failed: incorrect output for pigs-show.\nexpected 'first file' but your output is '$output'"
    exit 1
fi
