# gitlog2tsv

## Usage

    GIT_DIR=/path/to/repository/.git sh /path/to/gitlog2tsv.sh

## Output

Lines with non-empty first tab-separated fields contain commit
information:

1. Commit hash
2. Parent hashes (separated by spaces if multiple. Empty if root)
3. Author name
4. Author email
5. Author timestamp
6. Committer name
7. Committer email
8. Committer timestamp
9. Refs (separated by spaces if multiple)
10. Commit message

Backslashes and tabs are escaped in fields 1-8 and 10, although only
commit message and author/committer names can have tabs.

Lines with empty first field and non-empty second field:

1. Old filename
2. New filename

Filenames are escape by Git.

Lines with empty first two fields:

1. Number of first line in a block of removed lines
2. Number of lines in a block of removed lines
3. Number of first line in a block of added lines
4. Number of lines in a block of added lines
