#use: ./getCVCConfig.sh domainName cvcredName 

curDate=`(date +%e-%b-%Y-T-%H-%M-%S) | sed 's/ //'`
domainName=$1
cvcredName=$2

echo domainname: $domainName
echo cvcredname: $cvcredName

incurlFile=runFilesTemp/"getCVCConfig_"$cvcredName"_"$curDate".xml"
cvcConfigExport=runFilesTemp/"CVCConfigExport_"$cvcredName"_"$curDate".xml"
cvcConfigImport=runFilesTemp/"CVCConfigImport_"$cvcredName"_"$curDate".xml"

cat templates/getCVCConfigTemplate.xml |  sed "s|ZULAZULADOMAINNAMEZULA|${domainName}|g" | sed "s|ZULAZULACVPNAMEZULAZULA|${cvcredName}|g" > $incurlFile

curl -k -u admin:Deneme123 -d @$incurlFile https://192.168.92.136:5550/service/mgmt/3.0 > $cvcConfigExport 

rm $incurlFile

echo Exported CVC config file for $cvcredName : $cvcConfigExport

cat templates/addcerttoCVCTemplate.xml |  sed "s|ZULAZULADOMAINNAMEZULA|${domainName}|g" | sed "s|ZULAZULACVCEXPORTFILEZULAZULA|${cvcConfigExport}|g" > $cvcConfigImport

echo TobeManuallyModified import file for $cvcredName : $cvcConfigImport  
