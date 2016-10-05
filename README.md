# Azure Storage Parallel Uploader (ASPU)

## Get Started
### Install
#### 1. Install requirement tools
```
  $ sudo pip install blobxfer -y
```
If you got errors that not found pip, try below as,
###### Ubuntu  
```
  $ sudo apt-cache update
  $ sudo apt-get install python-pip
```
###### CentOS 7 or later  
```
  $ sudo yum groupinstall "Development Tools"
  $ sudo yum install python-pip
```


If you want to use mongodb on local  
###### Ubuntu  
```
  $ sudo apt-cache update
  $ sudo apt-get install mongodb-server mongodb -y
```
###### CentOS 6 or later  
```
  $ sudo yum install epel-release -y
  $ sudo yum install mongodb-server mongodb -y
```

#### 2. Get sources from GitHub
```
  $ git clone https://bitbucket.org/shkawan/aspu.git
```

#### 3. Setup  
  You need a superuser power. 
  You might be asked sudo password.
```
  $ cd aspu/
  $ sh ./setup.sh
```
  If you got some messages, you should follow them.  

#### 4. Test
```
  $ perl -c ./aspu
```
  If you got a message "Syntax OK", everything would be working !


## Configure
### $HOME/config.yaml
Edit your config.yaml placed your home directory
```
  $ cp sample-config.yaml $HOME/config.yaml
```

Minimum config:  
1. Set your storage accounts
2. Select a logic to select storage  
  For now, it can support logics dispatch_by_filename and roundrobin

## Usage

## Pre requirement
You need to prepare a list to upload.
```
/mnt/backup/GST/C/readblock.jpg
/mnt/backup/GST/C/writeblock.jpg
/mnt/backup/GST/C/deadlock.jpg
/mnt/backup/GST/C/rwlocks1.jpg
/mnt/backup/GST/C/simplelock.jpg
/mnt/backup/GST/JAVA/readblock.jpg
/mnt/backup/GST/JAVA/writeblock.jpg
  :
```

## Run
### 
To run the script,
You have to set environment value AZURE_STORAGE_SELECT_CONFIG_PATH that is used to config path.
if not, config path is your HOME directory.
```
  $ export AZURE_STORAGE_SELECT_CONFIG_PATH=$HOME/aspu
```
For simply start, 
You can copy dispatch.json and define-storage.yaml to $HOME or AZURE_STORAGE_SELECT_CONFIG_PATH,
and edit for your Azure system environment.

### Example1
Parallelism is Single.(Default)
```
  $ ./aspu < list.txt
```

### Example2
Parallelism is 10.
```
  $ ./aspu -p 10 < list.txt
```

## Writing to DB
### MongoDB(or You can use Azure DocumentDB with MongoDB compatible feature)
Default
```
  $ mongo azure_storage
  > db.store.find()
  { "_id" : ObjectId("57e0059c135f4e5189c344fd"), "container" : "foo", "filename" : "test1pix.jpg", "path" : "/mnt/backup/new-managed000/usr/local/src/php-5.3.14/ext/standard/tests/image/test1pix.jpg", "storage" : "storage9391" }
  { "_id" : ObjectId("57e0059c135f4e5189c344fe"), "container" : "bar", "filename" : "image025.jpg", "path" : "/mnt/backup/new-managed000/usr/local/src/php-5.3.14/ext/exif/tests/image025.jpg", "storage" : "storage2101" }
    :
```
You can use Azure DocumentDB with MongoDB compatible instead of original MongoDB.

## Logging and Notification
### Syslog
Facility is local0, Level is info
Example(Default on Ubuntu)
```
  $ tail -f /var/log/syslog
```
### to Slack
At first, you need to get incoming api webhook uri, and set it to your environment value MY_SLACK_API
```
  $ export MY_SLACK_API=https://hooks.slack.com/services/T1DF00000/B2DP00000/y7kqe88JsXrOwP0000000000
  $ ./aspu --slack channelname -p 5
```

### to mail
```
  $ ./aspu --mail foo@uname.link -p 5
```
