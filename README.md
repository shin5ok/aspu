# Azure Storage parallel uploader

## Get Started
### Install
1. Install requirement tools
```
  $ sudo pip install blobxfer -y
```

2. Get source from GitHub
```
  $ git clone https://bitbucket.org/shkawan/storage-sync.git
```

3. Setup  
  You need a superuser power. 
  You might be asked sudo password.
```
  $ cd storage-sync/
  $ sh ./setup.sh
```
  If you got some messages, you should follow them.  

4. Test
```
  $ perl -c ./azure-storage.pl
```
  If you got a message "Syntax OK", everything would be working !


## Configure
### dispatch.json

### define-storage.yaml

## Usage

## Pre requirement
You need to prepare a list to upload.
```
/mnt/backup/managed000/gsg_txn/C/readblock.jpg
/mnt/backup/managed000/gsg_txn/C/writeblock.jpg
/mnt/backup/managed000/gsg_txn/C/deadlock.jpg
/mnt/backup/managed000/gsg_txn/C/rwlocks1.jpg
/mnt/backup/managed000/gsg_txn/C/simplelock.jpg
/mnt/backup/managed000/gsg_txn/JAVA/readblock.jpg
/mnt/backup/managed000/gsg_txn/JAVA/writeblock.jpg
  :
```

## Run
### 
To run the script,
You have to set environment value AZURE_STORAGE_SELECT_CONFIG_PATH that is used to config path.
if not, config path is your HOME directory.
```
  $ export AZURE_STORAGE_SELECT_CONFIG_PATH=$HOME/storage-sync
```
For simply start, 
You can copy dispatch.json and define-storage.yaml to $HOME or AZURE_STORAGE_SELECT_CONFIG_PATH,
and edit for your Azure system environment.

### Example1
Parallelism is Single.(Default)
```
  $ perl ./azure-storage.pl < list.txt
```

### Example2
Parallelism is 10.
```
  $ perl ./azure-storage.pl -p 10 < list.txt
```

## Recording to DB
### MongoDB(DocumentDB with MongoDB compatible)
Default
```
  $ mongo azure_storage
  > db.store.find()
  { "_id" : ObjectId("57e0059c135f4e5189c344fd"), "container" : "foo", "filename" : "test1pix.jpg", "path" : "/mnt/backup/new-managed000/usr/local/src/php-5.3.14/ext/standard/tests/image/test1pix.jpg", "storage" : "storage9391" }
  { "_id" : ObjectId("57e0059c135f4e5189c344fe"), "container" : "bar", "filename" : "image025.jpg", "path" : "/mnt/backup/new-managed000/usr/local/src/php-5.3.14/ext/exif/tests/image025.jpg", "storage" : "storage2101" }
    :
```
You can use Azure DocumentDB with MongoDB compatible instead of original MongoDB.

## Logging 
### Syslog
Facility is local0, Level is info
Example(Default on Ubuntu)
```
  $ tail -f /var/log/syslog
```
### to Slack
At first, you need to get incoming api webhook uri, and set it to your environment value SLACK_API
```
  $ export SLACK_API=https://hooks.slack.com/services/T1DF00000/B2DP00000/y7kqe88JsXrOwP0000000000
  $ perl ./azure_storage --slack channelname -p 5
```

