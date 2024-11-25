mkdir /home # Attempt to create a duplicate directory
add /bin/ls # Attempt to add a duplicate file
rm /home # Attempt to remove a non-empty directory
rmdir /bin # Invalid command (should be 'rm')
mkdir /invalid/path # Invalid path (parent directory doesn't exist)
add /home/jane/documents/report.docx # Attempt to add a duplicate file
rm /home/john/missing.txt # Attempt to remove a file that doesn't exist
mv /home/alice /home/jane # Attempt to move a directory to an existing location
cp /home/bob /home/user2 # Invalid command (cp not implemented)
ls /fake/directory # Invalid path (directory doesn't exist)