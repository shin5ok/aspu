#!/bin/bash

if ! which pip > /dev/null;
then
  echo "You must install pip, and run as below,"
  echo "$ sudo pip install blobxfer -y"
fi

echo -n "It might take for a while..."
for dummy in {1..5};
do
  echo -n "."
  sleep 1
done
echo
sudo true

curl -L http://cpanmin.us/ | sudo perl - LWP::UserAgent LWP::Protocol::https MongoDB Parallel::ForkManager Class::Accessor::Lite JSON YAML opts

if perl -c ./azure-storage.pl > /dev/null 2>&1;
then
  echo "Setup has been completed"
else
  echo "*** Setup has been ended as FAIL"
fi

