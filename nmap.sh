# A nmap enumeration script written in Bash. 
#
# This script will run a bunch of nmap scans against a host, then will slice
# and dice some of the output to make it more useful/easier to read.# This 
# should help during the enumeration phase of a pentesting engagement,
# capture the flag game, or other similar activity.
#
# Instructions:
# $> sudo ./bash.sh 127.0.0.1
#
# Disclaimer: Use at your own risk. Do not run this tool against IP addresses
# that you do not have explicit permission to scan.
#
# Don't say you weren't warned ;-)
#
#!/bin/bash   
IP=$1
TOP20_TCPSTAN=tcp_standard_top20.txt
TOP20_GREP=grep_top20.txt
SNMP_GREP=grep_snmp.txt
BANNER_GREP=banner_snmp.txt
REG_TCPSTAN=tcp_standard_REG.txt
REG_GREP=grep_REG.txt
WEB_GREP=grep_WEB.txt
PING_GREP=grep_PING.txt
SSHKEY_GREP=grep_SSHKEY.txt

if [ -z "$IP"]
then
  echo "Usage: $0 host"
  exit 1
fi
mkdir $IP
nmap -v -sn $IP -oG $IP/$PING_GREP
nmap -p 80 $IP -oG $IP/$WEB_GREP
nmap  $IP -p 22 -sV --script=ssh-hostkey -oG $IP/$SSHKEY_GREP
nmap -sU --open -p 161 $IP -oG $IP/$SNMP_GREP
nmap -sT -A --top-ports=20 -oN $TOP20_TCPSTAN -oG $IP/$TOP20_GREP $IP
nmap -Pn -T4 -sS -sV -sC -oN $REG_TCPSTAN -oG $IP/$REG_GREP $IP
nmap -sS -O -p1-65535 --script unusual-port  -oG $IP/$BANNER_GREP
nmap -sS -O -p1-65535 --script banner $IP -oG $IP/$BANNER_GREP
grep Up $IP/$PING_GREP | cut -d " " -f 3-
grep open $IP/$WEB_GREP |cut -d " " -f 3-
