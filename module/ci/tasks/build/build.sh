#!/bin/bash

echo $CHECKSUM
echo $CHECKSUM_BASE64
#echo $BASE64_FILE_DATA
echo $BASE64_FILE_DATA > file_base64.file
#echo `shasum file_base64.file | awk '{print $1}'`

echo `wc -c file_base64.file`

echo `openssl dgst -sha1 concourse-release/module/files/testfile`
echo `openssl dgst -sha1 file_base64.file`

openssl base64 -A -in concourse-release/module/files/testfile -out testbase64.file

#echo `shasum file.file | awk '{print $1}'`
#echo `shasum testbase64.file`
echo `openssl dgst -sha1 testbase64.file`