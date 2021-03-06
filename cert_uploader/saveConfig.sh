#use: ./getCVCConfig.sh domainName cvcredName 

curDate=`(date +%e-%b-%Y-T-%H-%M-%S) | sed 's/ //'`
domainName=$1

echo domainname: $domainName


incurlFile=runFilesTemp/"saveConfig.xml"

cat templates/saveConfigTemplate.xml |  sed "s|ZULAZULADOMAINNAMEZULA|${domainName}|g"  > $incurlFile

curl -k -u admin:Deneme123 -d @$incurlFile https://192.168.92.136:5550/service/mgmt/3.0 

#rm $incurlFile

