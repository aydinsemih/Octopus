echo " "
echo UPLOADING CERT FILES BEGIN::
domainName=$1
CVCName=$2
certDirectory=$3

echo " "
echo Checking certificate file formats and converting to UTF8

utfConverterfile=runFilesTemp/convert-cert-to-utf8.sh
ls -lrt $certDirectory | grep .pem | awk -v certDirectory="$certDirectory" '{print "sed -i \"1s/^\\xEF\\xBB\\xBF//\" " certDirectory"/"$9}' > $utfConverterfile
chmod +x $utfConverterfile
sh $utfConverterfile
rm $utfConverterfile

certUploader=runFilesTemp/cert_uploader_temp.sh
certListtoAddCVCImport=runFilesTemp/cert_list_to_add_cvc_import
ls -lrt $certDirectory | grep .pem | sed 's/.pem//' | awk -v domN="$domainName" -v certDir="$certDirectory" '{print "./uploadCertFile.sh", domN,$9,certDir"/"$9".pem"}' > $certUploader

chmod +x $certUploader
. $certUploader
rm $certUploader


echo " "
echo UPLOADING CERT FILES END:::

read -n  3 -p "Certificates uploaded. Do you want to exit before creating certificat objects? YES/NOP" respCC
if [ $respCC = "YES" ]
then
exit 0
fi

echo " "
echo CREATING CERT OBJECTS ON DP BEGIN::
certCreator=runFilesTemp/cert_creator_temp.sh
ls -lrt $certDirectory | grep .pem | sed 's/.pem//' | awk -v domN="$domainName" '{print "./createCertObject.sh", domN,$9,$9}' > $certCreator
chmod +x $certCreator
. $certCreator
rm $certCreator
echo " "
echo CREATING CERT OBJECTS ON DP END:::

echo " "
echo GETTING CVC CONFIG EXPORT BEGIN::

./getCVCConfig.sh $domainName $CVCName

echo " "
echo GETTING CVC CONFIG EXPORT END:::

echo " "
echo PREPARING CERTLIST XML to add CVC CONFIG IMPORT BEGIN::
ls -lrt $certDirectory | grep ".pem" | sed 's/.pem//' | awk '{print "<Certificate class=\"CryptoCertificate\">" $9 "</Certificate>"}' > $certListtoAddCVCImport
echo The cert list file to add cvc import file: $certListtoAddCVCImport
echo " "
echo PREPARING CERTLIST XML to add CVC CONFIG IMPORT END:::

echo " "
echo "Now you should go and prepare xml files on above as described"
echo "Have you finished editing file:"
read -n  3 -p "Did you finished editing and want to continue processing YES/NOP" respX
if [ $respX = "YES" ] 
then
read -p "Enter full path of the modified xml file to add certs into the CVC?" respF
./importCertstoCVC.sh $respF
echo "Done"
fi

echo " "

read -n  3 -p "Do you want to save the modified config? YES/NOP" respY
if [ $respY = "YES" ]
then
./saveConfig.sh  $domainName
echo "Done"
fi
 

:
