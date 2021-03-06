#use: ./ 

curDate=`(date +%e-%b-%Y-T-%H-%M-%S) | sed 's/ //'`

incurlFile=$1

curl -k -u admin:Deneme123 -d @$incurlFile https://192.168.92.136:5550/service/mgmt/3.0 

rm $incurlFile

