# Nabaztag Server: replace nabd in python with a .NET 8 Application

This service is providing the same functionnalities as nabd and add Voice to Text and Text to Speech plus intent recognition into the service.

This version is still under development, see the section on limitations and service support

## .NET 8 Installation step

Install .NET 8 in /opt/dotnet with:

```bash
sudo curl -sSL https://dot.net/v1/dotnet-install.sh | sudo bash /dev/stdin --version "8.0.6" --verbose --runtime aspnetcore --install-dir "/opt/dotnet"
```
you will also need Libgpiod

```bash
sudo apt install gpiod
```

Create a folder for the server and give it to the pi user (for easy instalation and update)

```bash
sudo mkdir /opt/nabsrv
sudo chown pi /opt/nabsrv/
```

### Run the server by hand 
Then copy the binaries to /opt/nabsrv/ with WinSCP.

To start the server by hand you will need to disable nabd and reboot:

```bash
sudo systemctl is-active --quiet nabd.socket && sudo systemctl stop nabd.socket
sudo systemctl disable nabd.socket
sudo systemctl is-active --quiet nabd && sudo systemctl stop nabd
sudo systemctl disable nabd
sudo reboot
```

then go to /opt/nabsrv and start it:

```bash
cd /opt/nabsrv
sudo /opt/dotnet/dotnet /opt/nabsrv/Nabaztag.ServerCore.dll -d -c
```


### Run the server automatically 
You can aslo run it automatically at nabaztag start by running the install script (untest)
it should disable nabd, create the Nabaztag ServerCore service and then reboot.

```bash
cd opt/nabsrv/
sudo bash installservercore.sh
```



## .NET 4.8 installation step

You'll need to setup a free Microsoft Azure account. See the (WebTts section)[../Nabaztag.WebTts/README.md] for more details on how to do this.

You need as well to create a LUIS.AI service. Go https://wwW.luis.ai and follow the procedure. This is a well free for the amount you'll need.

In Luis, import the intent (Nabaztag)[Nabaztag-Fr.lu] into Luis. Follow the documentation for this. This is a French file currently, but just write sentences in English or any other language you want on the intents. This is a basic example, you can of course create more intents and your custom ones.

Once you've done all this, copy the keys, adjust the regions and the voice you want to use in the setting file:

```json
{
  "CognitiveKey": "YOUR AZURE COGNITIVE SERVICES KEY",
  "CognitiveRegion": "westeurope",
  "LuisRegion": "westus",
  "LuisStage": "staging",
  "LuisAddId": "3e48f937-d0c5-4f04-ae3e-8cdc84e68bfb",
  "LuisKey": "YOUR LUIS KEY HERE",
  "Locale": "fr-FR",
  "ClockPhrase": "Il est très exactement {0} heures {1} minutes et {2} secondes",
  "PrefferedVoice": {
    "Name": "Microsoft Server Speech Text to Speech Voice (fr-FR, DeniseNeural)",
    "ShortName": "fr-FR-DeniseNeural",
    "Gender": "Female",
    "Locale": "fr-FR",
    "SampleRateHertz": "24000",
    "VoiceType": "Neural"
  }
}
```

Simply copy on your Pi using WinSCP all the binaries and the modified ```settings.json``` file. You can use any other tool to copy all this. You can download the latest release or you can compile it using Visual Studio and the .NET Framework 4.8 on your Windows machine. 

Once you've created a directory, typically in /home/pi/nabserver run:
```bash
cd nabserver
sudo bash installserver.sh
```

This will take a bit of time, install all the dependencies needed (mono), will unregister the nabd service, register Nabaztag.Server and run it after a reboot. You'll notice that the rabbit will be available much faster than with the nabd service.

## Usage

Well, there's almost nothing to do :-) It will just work on its own! That said, few things to keep in mind:

- Be patient the first time you'll do voice recognition, press long, wait for the nose to get red and for the music to play
- Release and wait for the music to play, the recognition takes couple of seconds and the event is broadcasted to all the applications
- Second time is much faster, that said, try not to ask too many things at the NAbaztag all the time! This part is still a bit fragile :-)

If you double click, it will play a random choreography.

Enjoy!

## Limitations and service support

Here is the list of what has been and need to be implemented:

[x] Full support of nabd tcp protocole

[x] Full support for all the native services including the web confirugation page and all services configuration except RFID

[x] Full support for Sleep, Wakeup, Play, Recording notifications

[x] Support for events: Button, Ears, ASR

[ ] RFID support including event notification and tag detection into the web configuration page

[ ] Interactive mode

[x] Choreography Base 64 streaming

[x] Choreography chor file play

[x] Wav and mp3 audio playback

[x] Recording and recognition with ASR

[ ] Respiration (the violet led under slowly blinking)

[x] Animation when not busy

[ ] Circle between animation when not busy

[x] Tests for ears and leds

[x] Get statistics for system

[ ] Need to add support for voice to text in the protocole (that does not exist in nabd) 


Know limitations:
- The clockd deamon do not send properly sleep and wakeup events
- RFID is not implemented yet but if services want to subscribe to it, they can do
- After full pynab upgrade, the service needs to be reinstalled by running the ```installservercore.sh``` bash command. This will basically stop and disable the nabd service
- Sometimes when too fast for voice recognition, the service may crash, be patient! watch the sound and leds!


## Build info
For future version of raspberry pi zero that may not be supported with the included lib of rpi_ws281x you will need to rebuild it from sources:

```bash
git clone https://github.com/jgarff/rpi_ws281x.git
sudo apt-get install scons
cd rpi_ws281x/
scons
gcc -shared -o ws2811.so *.o
cp ws2811.so /opt/nabsrv/ws2811.so
```