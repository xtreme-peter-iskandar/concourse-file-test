#!/bin/bash
set -e -x



processFile(){
    LOCATION=$1
    DATA=$2
    FILENAME=$3
    FILENAME_BASE64=`echo -n $FILENAME.base64`
    BASE64_SHA=$4
    ORIGINAL_SHA=$5

    pushd $LOCATION
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
    popd
}

mkdir -p SECRETS/certs
mkdir -p SECRETS/SFDC-Certs
mkdir -p SECRETS/okta

processFile SECRETS/certs $CERTS_SAMLKEYSTORE_BASE64_DATA $CERTS_SAMLKEYSTORE_ORIGINAL_FILENAME $CERTS_SAMLKEYSTORE_BASE64_SHA1 $CERTS_SAMLKEYSTORE_ORIGINAL_SHA1

processFile SECRETS/okta $OKTA_XML_1_BASE64_DATA $OKTA_XML_1_ORIGINAL_FILENAME $OKTA_XML_1_BASE64_SHA1 $OKTA_XML_1_ORIGINAL_SHA1

processFile SECRETS/okta $OKTA_XML_2_BASE64_DATA $OKTA_XML_2_ORIGINAL_FILENAME $OKTA_XML_2_BASE64_SHA1 $OKTA_XML_2_ORIGINAL_SHA1

processFile SECRETS/okta $OKTA_XML_3_BASE64_DATA $OKTA_XML_3_ORIGINAL_FILENAME $OKTA_XML_3_BASE64_SHA1 $OKTA_XML_3_ORIGINAL_SHA1

processFile SECRETS/SFDC-Certs $SFDC_CERTS_SFDC_BASE64_DATA $SFDC_CERTS_SFDC_ORIGINAL_FILENAME $SFDC_CERTS_SFDC_BASE64_SHA1 $SFDC_CERTS_SFDC_ORIGINAL_SHA1

processFile SECRETS/SFDC-Certs $SFDC_CERTS_SFDC_PROD_BASE64_DATA $SFDC_CERTS_SFDC_PROD_ORIGINAL_FILENAME $SFDC_CERTS_SFDC_PROD_BASE64_SHA1 $SFDC_CERTS_SFDC_PROD_ORIGINAL_SHA1

processFile SECRETS/SFDC-Certs $SFDC_CERTS_SFDC_SANDBOX_BASE64_DATA $SFDC_CERTS_SFDC_SANDBOX_ORIGINAL_FILENAME $SFDC_CERTS_SFDC_SANDBOX_BASE64_SHA1 $SFDC_CERTS_SFDC_SANDBOX_ORIGINAL_SHA1

rm *.base64
ls -la





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