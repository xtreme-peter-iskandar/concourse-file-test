#!/bin/bash

echo $CHECKSUM
echo $CHECKSUM_BASE64
echo $BASE64_FILE_DATA
echo $BASE64_FILE_DATA > file_base64.file
echo `shasum file_base64.file | awk '{print $1}'`
#openssl base64 -d -in $