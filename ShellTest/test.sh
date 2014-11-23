#!/bin/bash

# 用来逐行显示的方法，暂时可以弃用了
#function for_in_file() {
#	for i in `cat $1`
#		do 
#		echo $i | egrep -o $2  >> $DNS_TEMP_FILE
#	done
#}

HTML_ADDRESS="http://blog.sina.com.cn/s/blog_562c7b6d0100puv1.html"
DURATION_SLEEP=0.7

HTML_TEMP_FILE=./HTML.tmp
DNS_TEMP_FILE=./DNS.tmp
AVERAGE_TEMP_FILE=./AVERAGE.tmp

# 第二个参数是pattern；第一个参数是HTML文本；第三个参数是存储文件
function parse_with_html_pattern_to_file() {
	egrep -o $2 $1 > $3
}

function download_with_address_to_file() {
	curl $1 > $2
}

function ping_IP_with_file_to_file() {
    rm $2

    for ip in `cat $1`
        do
        time=$(ping -c 5 $ip)
        average=$(echo $time | grep -o --color 'stddev.*/' | egrep -o --color '/.*?/' | egrep -o --color '\d+.+\d+')
        echo $average
        echo $average >> $2
    done
}

# download DNS HTML
echo sync with net
sleep $DURATION_SLEEP
download_with_address_to_file $HTML_ADDRESS $HTML_TEMP_FILE

# parseing DNS from HTML
#for_in_file $HTML_TEMP_FILE '((\d{1,3}\.){3})(\d{1,3})'
parse_with_html_pattern_to_file $HTML_TEMP_FILE "((\d{1,3}\.){3})(\d{1,3})" $DNS_TEMP_FILE
echo parsing HTML...
sleep $DURATION_SLEEP
#cat -n $DNS_TEMP_FILE

ping_IP_with_file_to_file $DNS_TEMP_FILE $AVERAGE_TEMP_FILE

# cleanup TMP
rm $HTML_TEMP_FILE
rm $DNS_TEMP_FILE
echo done
