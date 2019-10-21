if [ -z "$1" ]; then
	echo "Missing arguments. Usage:"
	echo "./rspeer-linux.sh <link key>"
	echo ""
	echo "Get your link key from: https://app.rspeer.org/#/bot/management"
    exit 1
fi

sudo apt-get update -y
sudo apt-get install screen -y
sudo apt-get install openjdk-11-jre -y

#install a lightweight desktop environement, with XRDP
sudo apt-get install xfce4 -y
sudo apt-get install xfce4-terminal -y
sudo apt-get install firefox-esr -y
sudo apt-get install xvfb -y
#sudo apt-get install xrdp -y
sudo apt-get install x11vnc -y

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
	#xvfb
	echo "screen -ls" > /home/pi/check.sh	
	echo "if !(ls -A -1 /var/run/screen/S-pi | grep "^[0-9]*\.xvfb$")" >> /home/pi/check.sh
	echo "then" >> /home/pi/check.sh
	echo "screen -dmS xvfb sh -c 'Xvfb :10.0'" >> /home/pi/check.sh
	echo "fi" >> /home/pi/check.sh
	
	#x11vnc
	echo "screen -ls" >> /home/pi/check.sh
	echo "if !(ls -A -1 /var/run/screen/S-pi | grep "^[0-9]*\.x11vnc$")" >> /home/pi/check.sh
	echo "then" >> /home/pi/check.sh
	echo "screen -dmS x11vnc sh -c 'x11vnc -xkb -noxrecord -forever -noxfixes -noxdamage -display :10.0'" >> /home/pi/check.sh
	echo "fi" >> /home/pi/check.sh

	#loader
	echo "screen -ls" >> /home/pi/check.sh
	echo "if !(ls -A -1 /var/run/screen/S-pi | grep \"^[0-9]*\.loader$\")" >> /home/pi/check.sh
	echo "then" >> /home/pi/check.sh
    	echo "screen -dmS loader sh -c 'DISPLAY=:10.0 /home/pi/.rspeer/node/bin/node /home/pi/.rspeer/loader.js'" >> /home/pi/check.sh
    	echo "fi" >> /home/pi/check.sh
    	chmod +x /home/pi/check.sh
    	/home/pi/check.sh
fi

#-------------------
#    add check.sh to crontab, to run every 1 min
#-------------------

echo "$(crontab -l ; echo 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin')" | crontab -
echo "$(crontab -l ; echo '* * * * * /home/pi/check.sh')" | crontab -
