# Date Variable
current_date=$(date "+%Y-%m-%d-%H")
# Create OutPutFolder 
output_folder="output-$current_date"
mkdir -p "$output_folder"

echo "8.8.8.8" >> $output_folder/resolver.txt
echo "4.2.2..4" >> $output_folder/resolver.txt

echo "crt-sh start ... " 
curl -s "https://crt.sh/?q=$1&output=json" | jq -r ".[].name_value" | sort -u >> $output_folder/$1-crt-sh.txt
curl -s "https://crt.sh/?o=$2&output=json" | jq -r '.[].common_name' | sed 's/\*\.//g' | sort -u >> $output_folder/$1-crt-sh.txt # ToDo - OutPut File
cat $output_folder/$1-crt-sh.txt | sort -u >> $output_folder/$1-crt-sh-sort-$current_date.txt # ToDo - OutPut File
echo "crt-sh done :) " 

echo " abuseipdb start ... " 
curl -s "https://www.abuseipdb.com/whois/ford.com" --cookie "cf_clearance=JeEh9iZ3Wi6ykNZV204KzG1wrQjuJ1cN1fpeUguTZF4-1710783702-1.0.1.1-4ojY10zjUmPpqBTVSVDH6RTsvhZG5_ILfc5sKAUsJ_jWc91O4NtnpIVlv2KTV5xywdGh89cxnpPnG02tb0cveA; cookie_consent_functional=allow; cookie_consent_analytical=allow; _ga=GA1.2.1744967257.1706335164; _ga_MBHS9QPB71=GS1.1.1706335163.1.0.1706335163.0.0.0; _ga_NL1PG6T2D0=GS1.1.1706335164.1.0.1706335164.0.0.0; _ga_EPWK5WX9YH=GS1.2.1706335165.1.0.1706335165.60.0.0; env=05pQof8LRtw7HlMM1O2Z; remember_web_59ba36addc2b2f9401580f014c7f58ea4e30989d=eyJpdi…EN=eyJpdiI6ImRyenJLUUc1dVMybzhlWUZOZTdxWkE9PSIsInZhbHVlIjoieGN6STFzbTR4UzN6QlRUOXBcL2d4R0tEUENEUnVaWGcxUEtOS1wvNk5IQkQ4K0FtbEhMSGRhQjlTWUllNU8zOXpsIiwibWFjIjoiNzJkOWUzMzM1OGE2Y2E4MzQ4MDBmZmYwYzU4N2ExOTY3ZDU0OGJjOTlmYmYyYWJjMzFjODU2ODQ5M2VjYzU0NSJ9; abuseipdb_session=eyJpdiI6IlV6U1p3Sm1tSzJoM3IxZE9PTXVpNVE9PSIsInZhbHVlIjoibGJuNkRjclM2SnZQZm5EOWQ5S1wvblNkNms2UjV2WmtvWEx6QWJVSTZRZVJpQUprN0x3ZnFOWDFLd1wvcEhGQ0JZIiwibWFjIjoiZWUwNDMwZWVjMDBlZTk5OTI4MzUzYWUxOWViNzE1MjMxMDY0YWJiZWUzYzc4ZmU3ZDNmMWUzZDZhZDBkODYzOCJ9" -H "user-agent: firefox" | grep -E '<li>\w.*</li>' | sed -E 's/<\/?li>//g' | sed -E "s/$/.ford.com/g"
echo "abuseipdb done :) "

echo " Rapiddns start ..."
curl -s "https://rapiddns.io/s/$1?full=1" | grep -E '<td>.*\..*\..*</td>' | sed 's/<\/\?td>//g' | grep ford >> $output_folder/$1-rapiddns-$current_date.txt #ToDo - OutPut File
echo "Rapiddns done :) " 

echo "chaos start ..." 
chaos -d $1 -silent >> $output_folder/$1-chaos-$current_date.txt #ToDo fix -> [FTL] Authorization token not specified
echo "chaos done :) "

echo "subfinder start ..." 
subfinder -d $1 -silent -all >> $output_folder/$1-subfinder-$current_date.txt
echo "subfinder done :) " 

echo "webarchive start ..."
curl -s "https://web.archive.org/cdx/search/cdx?url=*.$1&collaps=urlkey&fl=original" >> $output_folder/$1-webarchive-$current_date.txt

echo "github_subdomain start ..."
touch .token
echo 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 >> .token
github_subdomain -d $1 -k -e -q -t .token -silent -o $output_folder/$1-github-subdomain-$current_date.txt 
echo "github_subdomain done :) "

# add c99 subdomain and binaryedge 


echo "check dnsx Crt-sh "
cat $output_folder/$1-crt-sh-sort-$current_date.txt | dnsx -silent  >> $output_folder/$1-crt-sh-sort-live-$current_date.txt
echo "Crt-sh dnsx done" 

echo "check dnsx Abuseipdb"
cat $output_folder/$1-abuseipdb-$current_date.txt | dnsx -silent  >> $output_folder/$1-abuseipdb-live-$current_date.txt
echo "Absuseip dnsx done "
echo "check dnsx Rapiddns"
cat $output_folder/$1-rapiddns-$current_date.txt | dnsx -silent >> $output_folder/$1-rapiddns-live-$current_date.txt
echo "Rapiddns dnsx done"

echo "check dnsx chaos"
cat $output_folder/$1-chaos-$current_date.txt | dnsx -silent  >> $output_folder/$1-chaos-live-$current_date.txt
echo "chaos dnsx done"

echo "check dnsx subfinder"
cat $output_folder/$1-subfinder-$current_date.txt | dnsx -silent  >> $output_folder/$1-subfinder-live-$current_date.txt
echo "sufinder dnsx done " 

echo "check dnsx webarchive"
cat $output_folder/$1-webarchive-$current_date.txt | sort -u | dnsx -silent | sort -u >> $output_folder/$1-webarchive-live-$current_date.txt

echo "check dnsx github-subdomain"
cat $output_folder/$1-github-subdomain-$current_date.txt | dnsx -silent | sort -u >> $output_folder/$1-github-subdomain-live-$current_date.txt

echo "merge subdomais all providers start ..." 
cat $output_folder/*-live-$current_date.txt | sort -u >> $output_folder/subdomains-dnsx-live-$current_date.txt
echo "merge all live subdomains done :)"




