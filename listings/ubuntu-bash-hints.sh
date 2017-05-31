# show running process by name with headers
$ ps aux | egrep "python|PID"

### la
# sizes of files
$ ls -lah
# colored
$ ls -G
# count quantity of files inside folder
$ ls -1 | wc -l

### sizes
# check free disk space
$ df -h
# get folder size
$ du -hs
# get folders size inside another one
$ du -h --max-depth=1 some_folder

### search
# search recursive by folders
$ grep -r "/api/Profile/active_home_devices" static/
# search by file content
$ grep -R 'GCModel' SemanticProcessor/
# find by filename
$ find ~ -name readme.txt

### zipping/unzipping
# unzip tar.gz file
$ tar -xvzf filename.tar.gz
# zip something
$ zip archive_name source_name
# unzip something
$ unzip archive_name

# execute output of some command(assume it in text file)
$ $(cat filename)

# get the location of the executable link
$ readlink -f /usr/bin/java
/usr/lib/jvm/java-8-oracle/jre/bin/java

# display part of the file
$ cat filename | less
$ tail -200 filename
$ head -200 filename
$ head -n 1000 filename | tail
# display to stdout
$ echo SOMETHING

# get list of all listened ports
$ sudo netstat -peanut

# check memory every 1 second
$ watch -n 1 free -m

# as per tutorial: http://manpages.ubuntu.com/manpages/trusty/man1/enca.1.html
# get coding of document
$ enca filename
# change encoding of doc
$ enconv filename

# merge all files in folder to one
$ cat folder_path/* > new_file

# copy content of some text file(ssh for example)
$ cat ~/.ssh/id_rsa.pub | xclip -sel clip
# the same for mac
$ pbcopy < ~/.ssh/id_rsa.pub

# get source code of some package
http://askubuntu.com/questions/167468/where-can-i-find-the-source-code-of-ubuntu

# get dependencies
$ readelf -d some_exe

# find location of installed files
$ dpkg --listfiles libqt4-dev

# remove range of folders starts with numbers
$ rm -r output/logs/{17..26}*

# send stdout to file and display it to the bash at the same time
$ ./some_file.sh | tee -a logs.txt

# stop first running docker instance
# all runing| second line| container name    | stop container by name
$ docker ps | sed -n 2p  | awk '{print $NF}' | xargs docker stop

# get version of CUDA
$ dpkg -l | grep cuda
