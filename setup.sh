#!/bin/bash

if ! test -e /etc/redhat-release;
then
  echo "It seems not CentOS / RedHat OS"
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

LANG=C sudo sh -c "yum groupinstall 'Development Tools' -y"
PACKAGES="epel-release python-pip python-devel openssl-devel perl-devel mongodb mongodb-server"
for package in $PACKAGES
do
  sudo yum install $package -y
done
sudo pip install blobxfer
sudo /sbin/chkconfig mongod on
sudo /sbin/service mongod start

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

