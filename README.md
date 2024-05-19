# Pigs Version Control System

Pigs is a lightweight shell script-based version control system inspired by Git. It provides basic functionalities such as adding, committing, branching, and more, using a simple and familiar syntax.

## Getting Started

### Initializing a Repository

To start using Pigs with your project, you first need to create a new repository:

./pigs-init

This command creates a new .pig directory in your current folder, which will store all the necessary data for version control.

### Adding Files

To track files with Pigs, you need to add them to the index:

./pigs-add file1.txt file2.txt

This command stages the specified files, preparing them to be committed to your repository.

### Committing Changes

Once your files are staged, you can commit them to your repository:

./pigs-commit -m "Initial commit"

If you've modified and want to commit all tracked files, you can use the -a flag:

./pigs-commit -a -m "Update existing files"

### Managing Branches

With Pigs, you can manage multiple lines of development using branches:

./pigs-branch new-branch  # Create a new branch named 'new-feature'
./pigs-branch              # List all branches

### Switching Branches

To switch between branches:

./pigs-checkout new-branch

### Viewing Commit History

To see the commit logs:

./pigs-log

### Removing Files

To remove a file from the current index and the working directory:

./pigs-rm file.txt

### Showing File Information

To display information about files in the index or the working directory:

./pigs-show file1.txt

### Checking Status

To check the status of files in the index and the working directory:

./pigs-status

## Running Test

You can run the test files located in the root directory using the following command:

./test/test0*.sh
