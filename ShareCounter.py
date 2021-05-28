"""
shareCounter v1.2
The script reads data on a text file containing all shares their permissions to assess risks of unwanted access.
It counts the proportion of shares configured to allow access to everyone.
Data is then sent over MQTT protocol.
Script written by Arnaud Collart the 21/04/2021.
Documentations can be found on :  https://www.temporaryURL.com/doc/mydoc
"""

# importing dependecies
from os import system 
import argparse

# Args define
parser = argparse.ArgumentParser()
parser.add_argument("mosquitto", help="Mosquitto executable")
parser.add_argument("cafile", help="CA certificate")
parser.add_argument("certfile", help="Client certificate")
parser.add_argument("keyfile", help="Client key")
parser.add_argument("shareResult", help="File containing results")
parser.add_argument("broker", help="CN of MQTT Broker")
parser.add_argument("domain", help="Domain you'd like to work one")
args = parser.parse_args()

# establishing variables
shares = open(args.shareResult, 'r')
openShares = 0
string = "True"
i = 0

# reading the file line by line to find specified string
for line in shares:
    i += 1
    if string in line:
        openShares += 1

shares.close()
print(openShares)
print(i-openShares)

# send counters value to the broker
system(args.mosquitto
       + " -p 8883 --cafile " + args.cafile
       + " --cert " + args.certfile
       + " --key " + args.keyfile
       + " -h " + args.broker
       + " -m " + str(openShares)
       + " -t Security/ADDomain/" + args.domain + "/Pingcastle/openShares")
system(args.mosquitto
       + " -p 8883 --cafile " + args.cafile
       + " --cert " + args.certfile
       + " --key " + args.keyfile
       + " -h " + args.broker
       + " -m " + str(i-openShares)
       + " -t Security/ADDomain/" + args.domain + "/Pingcastle/otherShares")
