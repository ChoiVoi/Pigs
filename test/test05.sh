#!/bin/dash
if [ -d ".pig" ]; then
    rm -r ".pig"
fi

rm fil*
touch file1
touch file2
./pigs-init

echo "\nTest1: commit message correctly stored"
./pigs-add file1
./pigs-commit -m "commit!"
current_branch=$(head -n 1 .pig/branch_list)
stored_commit_msg=$(cat ".pig/branch/${current_branch}/commit/0/message")

if [ "$stored_commit_msg" = "commit!" ]; then
    echo "Test1 passed: commit message correctly stored"
else
    echo "Test1 failed: failed to store correct commit message.\nexpected 'commit!' but actually stored message is '$stored_commit_msg'"
    exit 1
fi


echo "\nTest2: after committing the files in index should be same as in the commit directory"
rm -r .pig
./pigs-init
echo "hello" >> file2
./pigs-add file1 file2
./pigs-commit -m "commit :)"

for file_index in ".pig/branch/$current_branch/index/"*; do
    file_name=$(basename "$file_index")
    file_commit=".pig/branch/$current_branch/commit/0/$file_name"

    if [ -f "$file_commit" ]; then
        diff_result=$(diff "$file_index" "$file_commit")
        if [ -n "$diff_result" ]; then
            echo "Test2 failed: file $file_name differs in index and commit 0"
            exit 1
        fi
    else
        echo "Test2 failed: file $file_name does not exist in commit 0"
        exit 1
    fi
done
echo "Test2 passed: All files are identical in index and commit 0."
