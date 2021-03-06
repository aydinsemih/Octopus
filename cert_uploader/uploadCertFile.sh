#use: ./uploadCertFile.sh domainName certfileName certfileFullPathwithFileName

curDate=`(date +%e-%b-%Y-T-%H-%M-%S) | sed 's/ //'`
domainName=$1
certfileName=$2
cerfileActual=$3


echo domainname: $domainName
echo certfilename: $certfileName
echo cerfile: $cerfileActual
base64 $cerfileActual > runFilesTemp/$certfileName"_base64"
cat templates/uploadCertFileTemplate_1.xml runFilesTemp/$certfileName"_base64" templates/uploadCertFileTemplate_2.xml |  sed "s|ZULAZULADOMAINNAMEZULA|${domainName}|g" |  sed "s|ZULAZULACERTFILENAMEZULAZULA|${certfileName}|g" > runFilesTemp/"uploadCertFileFor_"$certfileName"_"$curDate".xml"

incurlFile=runFilesTemp/"uploadCertFileFor_"$certfileName"_"$curDate".xml"

curl -k -u admin:Deneme123 -d @$incurlFile https://192.168.92.136:5550/service/mgmt/3.0

rm runFilesTemp/$certfileName"_base64"
rm runFilesTemp/"uploadCertFileFor_"$certfileName"_"$curDate".xml"

