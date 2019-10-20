# RSPeer-install-for-Raspberry-Pi

I made this script in order to automate the installation of the RSPeer client for Raspberry Pi.

Firstly, install a fresh image of Raspbian lite and then run the following commands:</br>

<code>sudo apt-get install git -y</code> </br>
<code>git clone https://github.com/V3XL/RSPeer-install-for-Raspberry-Pi.git</code></br>
<code>cd RSPeer-install-for-Raspberry-Pi</code></br>
<code>chmod +x rspeer-rpi.sh</code></br>
<code>./rspeer-rpi.sh <b>&lt;key&gt;</b></code></br>

(Replace <b>&lt;key&gt;</b> with your link key, found at https://app.rspeer.org/#/bot/management)

After this is done you should see your launcher appear in the "Connected Launchers" section at the following webpage:
https://app.rspeer.org/#/bot/management

You should now be able connect to the Raspberry Pi via remote desktop connection.
