#if loader is not running launch it

if !(ls -A -1 /var/run/screen/S-${USER} | grep "^[0-9]*\.loader$") #if node isn't running, terminate this screen 
					then
             $USER_HOME/.rspeer/node/bin/node $USER_HOME/.rspeer/loader.js
          fi
