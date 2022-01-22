#!/bin/bash
if [ $1 -lt 1 ]
then
	echo "Please choose a number greater than 0"
else
mkdir -p images logs tmp
touch ./logs/main.log
touch ./logs/wget.log

echo -e "\r" >> ./logs/main.log
echo "----------//----------//----------//----------//----------" >> ./logs/main.log
echo "Starting script..."
echo "Starting script..." >> ./logs/main.log
date >> ./logs/main.log
echo "The use of a VPN is advised although it may slow down the scrapping!!"
echo -e "\r"



COUNTER=0
FAIL=0

while [ $COUNTER -lt $1 ];
do
RL=`tr -dc a-z </dev/urandom | head -c 2`
RN=`shuf -i 999-10000 -n 1`
LINK="https://prnt.sc/${RL}${RN}"

echo -e "Scrapping $LINK"

cd tmp

wget -o /dev/null --reject html $LINK

IMGNAME1=`cat ${RL}${RN} | grep -oP 'https://image.prntscr.com/image/.*.png' | tail -c 70`

IMGNAMEF=${IMGNAME1#*/}

if [ -z "$IMGNAMEF" ]
then
	wget -o /dev/null --reject html $LINK

	IMGNAME1=`cat ${RL}${RN} | grep -oP 'https://image.prntscr.com/image/.*.jpeg' | tail -c 70`

	IMGNAMEF=${IMGNAME1#*/}

	if [ -z "$IMGNAMEF" ]
	then
		wget -o /dev/null --reject html $LINK

        	IMGNAME1=`cat ${RL}${RN} | grep -oP 'https://image.prntscr.com/image/.*.jpg' | tail -c 70`

	        IMGNAMEF=${IMGNAME1#*/}
		if [ -z "$IMGNAMEF" ]
        	then
			FAIL=$((FAIL+1))
			echo "Scrapping of $LINK failed" >> ../logs/main.log
			echo "Scrapping of $LINK failed"

		fi
	fi
fi


wget -o /dev/null https:/${IMGNAMEF}

cd ..

mv ./tmp/*.png ./images/${RL}${RN}.png 2>/dev/null
mv ./tmp/*.jpg ./images/${RL}${RN}.jpg 2>/dev/null
mv ./tmp/*.jpeg ./images/${RL}${RN}.jpeg 2>/dev/null

COUNTER=$((COUNTER+1))

done

echo -e "\r"
echo "Moving images that failed on the first attempt"
echo -e "\r" >> ./logs/main.log
echo "Contents of temp:" >> ./logs/main.log
ls -ltra tmp >> ./logs/main.log
rm -rf ./tmp/*.[1-9]*
mv ./tmp/*.* ./images 2>/dev/null

echo -e "\r"
echo "Cleaning temporary folders and files..."
rm -rf ./tmp

echo -e "\r"
echo "The script ended successfully!"


echo "$COUNTER URL(s) scrapped in $SECONDS seconds, averaging around $((SECONDS / COUNTER)) seconds per URL" 
echo "$FAIL URL(s) failed."
fi
