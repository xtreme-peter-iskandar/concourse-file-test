#!/bin/bash
set -e -x



processFile(){
    DATA=$1
    FILENAME=$2
    FILENAME_BASE64=`echo -n $FILENAME.base64`
    BASE64_SHA=$3
    ORIGINAL_SHA=$4

    echo -n $DATA > $FILENAME_BASE64
    BASE64_DIGEST=`openssl dgst -sha1 $FILENAME_BASE64 | awk {'print $2'} `
    if [[ "$BASE64_SHA" !=  "$BASE64_DIGEST" ]];
    then
        echo "Base 64 SHAs do not match for $FILENAME"
        exit 1
    fi

    openssl base64 -A -d -in $FILENAME_BASE64 -out $FILENAME

    DIGEST=`openssl dgst -sha1 $FILENAME | awk {'print $2'}`

    if [[ "$DIGEST" !=  "$ORIGINAL_SHA" ]];
    then
        echo "SHAs do not match for $FILENAME"
        exit 1
    fi

    ls -la
}

processFile $CERTS_SAMLKEYSTORE_BASE64_DATA $CERTS_SAMLKEYSTORE_ORIGINAL_FILENAME $CERTS_SAMLKEYSTORE_BASE64_SHA1 $CERTS_SAMLKEYSTORE_ORIGINAL_SHA1





#echo $CHECKSUM
#echo $CHECKSUM_BASE64
#echo -n $BASE64_FILE_DATA > file_base64.file
#
#
#echo `openssl dgst -sha1 file_base64.file`
#
#openssl base64 -A -d -in file_base64.file -out file.file
#
#echo `openssl dgst -sha1 file.file`
#cd concourse-release/test
#export KEYSTORE_FILE_PATH=keystore-file-path
#export CERTS_FILE_PATH=certs-file-path
#mkdir keystore-file-path
#mkdir certs-file-path
#
#touch keystore-file-path/test.jks
#touch certs-file-path/samlKeystore.jks
#
#
#pwd
#ls -la
#echo $KEYSTORE_FILE_PATH
#./gradlew copyKeystores
#
#ls -la build/generated-resources/keystores