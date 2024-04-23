#!/bin/bash

#Daniel Hernandez
#Simons Foundation Linux Technical Challenge

#Download the access logs of USASK WWW Server using WGET
#Unzip the GZIP Archive to get the plain-text log


#Checking if the file exists. If it does, skip this step so we won't need to download it again.
echo "Checking if usask_access_log exists..."
if ! test -f usask_access_log; then
        echo "File doesn't exist. Downloading a fresh copy and unzipping..."
	#Using WGET to download the file and GUNZIP to unzip it.
	wget ftp://ita.ee.lbl.gov/traces/usask_access_log.gz
	gunzip usask_access_log.gz
else
	#Skipping the prior download if it already exists.
	echo "File already exists. Skipping..."
fi

#Finding the number of requests received from mpngate1.ny.us.ibm.net
#In AWK, we look at the first field (where the URLs are) using regular expression to determine
#which lines contain requests from mpngate1.ny.us.ibm.net. Since AWK gives our results in new lines,
#we can use the wordcount (wc) command with a -l switch to retrieve the linecount, which will contain
#how many requests were made.
echo "Using AWK to find number of requests received from mpngate1.ny.us.ibm.net..."
req_count=$(awk '$1 ~ /mpngate1\.ny\.us\.ibm\.net/ {print $1}' usask_access_log | wc -l)
echo "There were" $req_count "requests made."

#Finding the number of unique usask.ca servers that made requests.
#We do something similar to the prior step, but this time we sort it using the sort command and
#use the -u switch to contain only the unique lines. We then feed it to wordcount as usual.
echo "Using AWK to find number of requests received from unique usask.ca servers..."
req_count=$(awk '$1 ~ /\.usask\.ca/ {print $1}' usask_access_log | sort -u | wc -l)
echo "There were" $req_count "unique requests made."
