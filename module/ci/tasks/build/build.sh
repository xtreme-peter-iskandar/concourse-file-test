#!/bin/bash

echo $CHECKSUM
echo $CHECKSUM_BASE64
echo $BASE64_FILE_DATA
echo $BASE64_FILE_DATA > file_base64.file
echo `shasum file_base64.file | awk '{print $1}'`

shasum -v

echo `shasum concourse-release/module/files/testfile`
openssl base64 -d -in file_base64.file -out file.file
openssl base64 -in concourse-release/module/files/testfile -out testbase64.file

echo `shasum file.file | awk '{print $1}'`
echo `shasum testbase64.file | awk '{print $1}'`
echo `openssl dgst -sha1 file.file`