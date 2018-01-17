#!/bin/bash

echo $CHECKSUM
echo $CHECKSUM_BASE64
echo -n $BASE64_FILE_DATA > file_base64.file


echo `openssl dgst -sha1 file_base64.file`

openssl base64 -A -d -in file_base64.file -out file.file

echo `openssl dgst -sha1 file.file`

export KEYSTORE_FILE_PATH=file.file

cd concourse-release/test
pwd
ls -la
echo $KEYSTORE_FILE_PATH
./gradlew printEnv
