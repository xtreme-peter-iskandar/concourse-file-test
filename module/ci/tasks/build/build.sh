#!/bin/bash

echo $CHECKSUM
echo $CHECKSUM_BASE64
echo -n $BASE64_FILE_DATA > file_base64.file


echo `openssl dgst -sha1 file_base64.file`

openssl base64 -A -d -in file_base64.file -out file.file

echo `openssl dgst -sha1 file.file`

export KEYSTORE_FILE_PATH=keystore-file-path
export CERTS_FILE_PATH=certs-file-path
mkdir keystore-file-path
mkdir certs-file-path


touch keystore-file-path/test.jks
touch certs-file-path/samlKeystore.jks

cd concourse-release/test
pwd
ls -la
echo $KEYSTORE_FILE_PATH
./gradlew printEnv

ls -la