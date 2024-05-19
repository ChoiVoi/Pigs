#!/bin/dash

if [ -d ".pig" ]; then
    rm -rf ".pig"
fi

rm fil*
./pigs-init

touch file1 file2 file3 file4

echo "Test1: check if removing file which is in current directory but not in index direcotry causes an error"

output=$(./pigs-rm file1 2>&1)
if [ "$output" = "pigs-rm: error: 'file1' is not in the pigs repository" ]; then
    echo "Test1 passed: correct output is produced"
else
    echo "Test1 failed: incorrect output is produced\nexpected output is 'pigs-rm: error: 'a' is not in the pigs repository' but your output is '$output'"
    exit 1
fi

echo "\nTest2: check if removing file which has staged changes in the index"
./pigs-add file1
output=$(./pigs-rm file1 2>&1)

if [ "$output" = "pigs-rm: error: 'file1' has staged changes in the index" ]; then
    echo "Test2 passed: correct output is produced"
else
    echo "Test2 failed: incorrect output is produced\nexpected output is 'pigs-rm: error: 'file1' has staged changes in the index' but your output is '$output'"
    exit 1
fi

echo "\nTest3: check if file in index is different to both the working file and the repository"
./pigs-commit -m "commit"
echo "change" >> file1
output=$(./pigs-rm file1 2>&1)

if [ "$output" = "pigs-rm: error: 'file1' in the repository is different to the working file" ]; then
    echo "Test3 passed: correct output is produced"
else
    echo "Test3 failed: incorrect output is produced\nexpected output is 'pigs-rm: error: 'file1' in the repository is different to the working file' but your output is '$output'"
    exit 1
fi

echo "\nTest4: check if file in index is different to both the working file and the repository"
./pigs-add file1
echo "change again" >> file1

output=$(./pigs-rm file1 2>&1)

if [ "$output" = "pigs-rm: error: 'file1' in index is different to both the working file and the repository" ]; then
    echo "Test4 passed: correct output is produced"
else
    echo "Test4 failed: incorrect output is produced\nexpected output is 'pigs-rm: error: 'file1' in index is different to both the working file and the repository' but your output is '$output'"
    exit 1
fi

echo "\nTest5: successfully remove the file from both index and current directory"
./pigs-add file1
echo "change again" >> file1
./pigs-add file1
./pigs-commit -m "commit"
./pigs-rm file1 2>&1

if [ ! -f "file1" ] && [ ! -f ".pig/branch/master/index/file1" ]; then
    echo "Test5 passed: successfully remove the file"
else
    if [ -f "file1" ] && [ -f ".pig/branch/master/index/file1" ]; then
        echo "test5 failed: fail to remove the file from both index and current directory"
        exit 1
    elif [ -f "file1" ]; then
        echo "Test5 failed: fail to remove the file from current directory"
        exit 1
    elif [ ! -f ".pig/branch/master/index/file1" ]; then
        echo "Test5 failed: failed to remove the file from index"
        exit 1
    fi
fi

echo "\nTest6: check if '--cached' option doesn't work when file in index is different to both current directory and commit"
./pigs-add file2
echo "change" >> file2
./pigs-commit -m "commit"
./pigs-add file2
echo "change again" >> file2
output=$(./pigs-rm --cached file2 2>&1)

if [ "$output" = "pigs-rm: error: 'file2' in index is different to both the working file and the repository" ]; then
    echo "Test6 passed: correct error message is produced"
else
    echo "Test6 failed: incorrect error message is produced\nexpected output is 'pigs-rm: error: 'file2' in index is different to both the working file and the repository' but your output is '$output'"
    exit 1
fi

echo "\nTest7: successfully remove file only from index"
./pigs-add file2
echo "change" >> file2
./pigs-commit -m "commit"
./pigs-add file2
echo "change again" >> file2
./pigs-add file2
./pigs-rm --cached file2

if [ ! -f ".pig/branch/master/index/file2" ] && [ -f "file2" ]; then
    echo "Test7 passed: successfully remove the file only from index"
else
    if [ -f ".pig/branch/master/index/file2" ] && [ -f "file2" ]; then
        echo "Test7 failed: failed to remove the file from index"
        exit 1
    elif [ ! -f ".pig/branch/master/index/file2" ] && [ ! -f "file2" ]; then
        echo "Test7 failed: successfully remove the file from index but the file is also removed from current directory"
        exit 1
    elif [ -f ".pig/branch/master/index/file2" ] && [ ! -f "file2" ]; then
        echo "Test7 failed: failed to remove the file from index but instead the file is removed from current directory"
        exit 1
    fi
fi

echo "\nTest8: check if '--force' option works with --cached"
./pigs-add file3
echo "change" >> file3
./pigs-commit -m "commit"
./pigs-add file3
echo "change again" >> file3
./pigs-rm --force --cached file3

if [ ! -f ".pig/branch/master/index/file3" ] && [ -f "file3" ]; then
    echo "Test8 passed: successfully remove the file only from index"
else
    if [ -f ".pig/branch/master/index/file3" ] && [ -f "file3" ]; then
        echo "Test8 failed: failed to remove the file from index"
        exit 1
    elif [ ! -f ".pig/branch/master/index/file3" ] && [ ! -f "file3" ]; then
        echo "Test8 failed: successfully remove the file from index but the file is also removed from current directory"
        exit 1
    elif [ -f ".pig/branch/master/index/file3" ] && [ ! -f "file3" ]; then
        echo "Test8 failed: failed to remove the file from index but instead the file is removed from current directory"
        exit 1
    fi
fi

echo "\nTest9: check if '--force' option works"
./pigs-add file3
./pigs-rm --force file3

if [ ! -f "file3" ] && [ ! -f ".pig/branch/master/index/file3" ]; then
    echo "Test9 passed: successfully remove the file"
else
    if [ -f "file3" ] && [ -f ".pig/branch/master/index/file3" ]; then
        echo "test9 failed: fail to remove the file from both index and current directory"
        exit 1
    elif [ -f "file3" ]; then
        echo "Test9 failed: fail to remove the file from current directory"
        exit 1
    elif [ ! -f ".pig/branch/master/index/file3" ]; then
        echo "Test9 failed: failed to remove the file from index"
        exit 1
    fi
fi