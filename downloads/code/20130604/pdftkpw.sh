#!/bin/sh
PDFIN=$1
PDFOUT=`echo $1 | sed -e "s/\.[^.]*$/pw.pdf/"`
len=`echo $RANDOM % 5 + 14 | bc`

[ -z $len ] && len="8"
char='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
i=1
while [ $i -le $len ]; do
    dm=$(( (RANDOM % ${#char}) ))
        str="${str}${char:${dm}:1}"
	    i=$(( i+1 ))
done

PW="$str"
PW=`echo "fjajfpsjpdsgs"`
pdftk $PDFIN output $PDFOUT owner_pw $PW
