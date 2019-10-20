if [ -z "$1" ]; then
	echo "Missing arguments. Usage:"
	echo "./rspeer-linux.sh <link key>"
	echo ""
	echo "Get your link key from: https://app.rspeer.org/#/bot/management"
    exit 1
fi

sudo apt-get update -y
sudo apt-get install screen -y

wget https://nodejs.org/dist/v10.14.2/node-v10.14.2-linux-armv7l.tar.xz
tar xf node-v10.14.2-linux-armv7l.tar.xz
sudo rm -r node-v10.14.2-linux-armv7l.tar.xz

mkdir /home/pi/.rspeer
touch /home/pi/.rspeer/key
echo $1 > /home/pi/.rspeer/key
mv node-v10.14.2-linux-armv7l /home/pi/.rspeer/node

cd /home/pi/.rspeer
wget https://download.rspeer.org/launcher/loader.js

#-------------------
#    create check.sh
#-------------------
if [ ! -f "/home/pi/check.sh" ]; then #if script doesn't exist
	touch /home/pi/check.sh
	echo "if !(ls -A -1 /var/run/screen/S-pi | grep \"^[0-9]*\.loader$\")" >> /home/pi/check.sh
	echo "then" >> /home/pi/check.sh
    echo "screen -dmS loader sh -c '/home/pi/.rspeer/node/bin/node /home/pi/.rspeer/loader.js'" >> /home/pi/check.sh
    echo "fi" >> /home/pi/check.sh
    chmod +x /home/pi/check.sh
    /home/pi/check.sh
fi

#-------------------
#    add check.sh to crontab, to run every 1 min
#-------------------

echo "$(crontab -l ; echo 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin')" | crontab -
echo "$(crontab -l ; echo '* * * * * /home/pi/check.sh')" | crontab -
