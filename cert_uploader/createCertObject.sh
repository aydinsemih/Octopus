#use: ./createCertObject.sh domainName certObjectName certFileNameonDP

curDate=`(date +%e-%b-%Y-T-%H-%M-%S) | sed 's/ //'`
domainName=$1
certObjectName=$2
certFileNameonDP=$3


echo domainname: $domainName
echo certobjectname: $certObjectName
echo certfilenameondatapower: $certFileNameonDP

incurlFile=runFilesTemp/"createCertObjectFor"$certfileName"_"$curDate".xml"

cat templates/createCertObjectTemplate.xml |  sed "s|ZULAZULADOMAINNAMEZULA|${domainName}|g" | sed "s|ZULAZULACERTOBJECTNAMEZULAZULA|${certObjectName}|g" |  sed "s|ZULAZULACERTFILENAMEONDPZULAZULA|${certFileNameonDP}|g" > $incurlFile

curl -k -u admin:Deneme123 -d @$incurlFile https://192.168.92.136:5550/service/mgmt/3.0

rm $incurlFile
