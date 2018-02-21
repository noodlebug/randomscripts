#!/bin/bash

# MY CURRENT IP
MYIP=`dig me.nodebug.co.uk +short`

# GET THE UFW RULE NUMBER MATCHING THE COMMENT STRING
UFWNUM=`ufw status numbered | grep me.nodebug.co.uk | cut -d'[' -f2 | cut -d ']' -f1`

# GET THE IP FROM THE UFW RULE
UFWIP=`ufw status numbered | grep me.nodebug.co.uk | awk '{print $5}'`

if [ -z ${UFWNUM} ]; then
  echo "No IP set, setting from scratch"
  yes | ufw allow from ${MYIP} to any port 53 comment 'me.nodebug.co.uk'
elif [ ${MYIP} == ${UFWIP} ]; then
  echo "UFW is up to date, not doing anything"
else
  echo "IP is out of sync, updating"
  yes | ufw delete ${UFWNUM}
  yes | ufw allow from ${MYIP} to any port 53 comment 'me.nodebug.co.uk'
fi

