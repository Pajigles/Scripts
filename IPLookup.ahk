^!i::
InputBox, UserInput, Search IP, , , 400, 100
if ErrorLevel
ExitApp
else
Run chrome.exe -new-window
sleep, 300
Run https://www.abuseipdb.com/check/%UserInput%
Sleep, 250
Run https://exchange.xforce.ibmcloud.com/ip/%UserInput%
Sleep,250
Run https://www.shodan.io/host/%UserInput%
Sleep,250
Run https://otx.alienvault.com/indicator/ip/%UserInput%
Sleep,250
Run https://viz.greynoise.io/query/?gnql=%UserInput%
Sleep, 250
Run https://www.virustotal.com/gui/ip-address/%UserInput%/detection
