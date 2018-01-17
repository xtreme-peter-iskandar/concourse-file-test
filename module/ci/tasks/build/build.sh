#!/bin/bash
set -e -x
echo $CHECKSUM
echo $CHECKSUM_BASE64
echo -n $BASE64_FILE_DATA > file_base64.file


echo `openssl dgst -sha1 file_base64.file`

openssl base64 -A -d -in file_base64.file -out file.file

echo `openssl dgst -sha1 file.file`
cd concourse-release/test
export KEYSTORE_FILE_PATH=keystore-file-path
export CERTS_FILE_PATH=certs-file-path
mkdir keystore-file-path
mkdir certs-file-path

touch keystore-file-path/test.jks
touch certs-file-path/samlKeystore.jks


pwd
ls -la
echo $KEYSTORE_FILE_PATH
./gradlew copyKeystores

ls -la build/generated-resources/keystores