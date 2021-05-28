"""
SMBParser v1.3
The script reads data on a text file containing all SMB shares configuration informations to find potential
vulnerabilities
as SMBv1 is an old protocol which isn't recommended anymore due to known vulnerabilities.
It then counts all shares where SMBv1 is enabled and sends the data to the broker via MQTT.
Script written by Arnaud Collart the 22/04/2021.
Documentations can be found on :  https://www.temporaryURL.com/doc/mydoc
"""

# importing libraries
from os import system
import argparse
import pandas as pd

# Args define
parser = argparse.ArgumentParser()
parser.add_argument("mosquitto", help="Mosquitto executable")
parser.add_argument("cafile", help="CA certificate")
parser.add_argument("certfile", help="Client certificate")
parser.add_argument("keyfile", help="Client key")
parser.add_argument("csv", help="SMB report")
parser.add_argument("broker", help="CN of MQTT broker")
parser.add_argument("domain", help="Domain you'd like to work on")
args = parser.parse_args()

# creating variables and instances
df = pd.read_csv(args.csv, delimiter="\t")
i = 0
counter = 0

# browsing the data to search specified string
while i < len(df):
    if str(df["SMB1 with dialect NT LM 0.12"][i]) == "Yes":
        counter += 1
    i += 1

print(counter)
print(i-counter)

# publishing data via MQTT
system(args.mosquitto
       + " -p 8883 --cafile " + args.cafile
       + " --cert " + args.certfile
       + " --key " + args.keyfile
       + " -h " + args.broker
       + " -m " + str(i-counter)
       + " -t Security/ADDomain/" + args.domain + "/Pingcastle/smbOther")
system(args.mosquitto
       + " -p 8883 --cafile " + args.cafile
       + " --cert " + args.certfile
       + " --key " + args.keyfile
       + " -h " + args.broker
       + " -m " + str(counter)
       + " -t Security/ADDomain/" + args.domain + "/Pingcastle/smbv1enabled")
