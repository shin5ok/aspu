#!/bin/bash

if ! ( which gcc > /dev/null && which make > /dev/null );
then
  echo "You need to install 'Developer Tools'"
  echo "If you are on RedHat/CentOS, you should type as below,"
  echo "\$ export LANG=C"
  echo "\$ sudo yum groupinstall 'Developer Tools'"
  exit 1
fi

if ! ( which pip > /dev/null && which blobxfer > /dev/null );
then
  echo "You need to install pip, and run as below,"
  echo "\$ sudo pip install blobxfer"
  exit 1
fi

echo -n "It might take for a while"
for dummy in {1..5};
do
  echo -n "."
  sleep 1
done
echo
sudo true

PERL_MONGODB_WITH_SSL=1
export PERL_MONGODB_WITH_SSL
curl -L http://cpanmin.us/ | sudo perl - Sys::Syslog Fatal LWP::UserAgent LWP::Protocol::https MongoDB Parallel::ForkManager Class::Accessor::Lite JSON YAML opts

echo
echo
if perl -c ./aspu > /dev/null 2>&1;
then
  echo "Setup has been completed"
else
  echo "*** There would be some ERRORS"
fi

