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

#install a desktop environement
sudo apt-get install xfce4 -y
sudo apt-get install xfce4-terminal -y
sudo apt-get install firefox-esr -y
sudo apt-get install xvfb -y
#sudo apt-get install xrdp -y
sudo apt-get install x11vnc -y

#now using new launcher
wget https://rspeer.nyc3.digitaloceanspaces.com/console_launcher/rspeer-launcher-arm-linux
sudo mv rspeer-launcher-arm-linux /home/pi/
sudo chmod +x /home/pi/rspeer-launcher-arm-linux

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
	
	#xfce4
	echo "screen -ls" >> /home/pi/check.sh	
	echo "if !(ls -A -1 /var/run/screen/S-pi | grep "^[0-9]*\.xfce4$")" >> /home/pi/check.sh
	echo "then" >> /home/pi/check.sh
	echo "screen -dmS xfce4 sh -c 'DISPLAY=:10.0 startxfce4'" >> /home/pi/check.sh
	echo "fi" >> /home/pi/check.sh
		
	#launcher
	echo "screen -ls" >> /home/pi/check.sh
	echo "if !(ls -A -1 /var/run/screen/S-pi | grep \"^[0-9]*\.launcher$\")" >> /home/pi/check.sh
	echo "then" >> /home/pi/check.sh
    	echo "screen -dmS launcher sh -c 'DISPLAY=:10.0 /home/pi/rspeer-launcher-arm-linux'" >> /home/pi/check.sh
    	echo "fi" >> /home/pi/check.sh
    	chmod +x /home/pi/check.sh
    	/home/pi/check.sh
fi

#-------------------
#    add check.sh to crontab, to run every 1 min
#-------------------

echo "$(crontab -l ; echo 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin')" | crontab -
echo "$(crontab -l ; echo '* * * * * /home/pi/check.sh')" | crontab -
