#!/bin/bash

echo $CHECKSUM
echo $CHECKSUM_BASE64
#echo $BASE64_FILE_DATA
echo -n $BASE64_FILE_DATA > file_base64.file
#echo `shasum file_base64.file | awk '{print $1}'`

echo `openssl dgst -sha1 file_base64.file`

openssl base64 -A -d -in file_base64.file -out file.file

echo `openssl dgst -sha1 file.file`
#echo `shasum file.file | awk '{print $1}'`
#echo `shasum testbase64.file`
#echo `openssl dgst -sha1 testbase64.file`