#!/bin/bash

echo y| apt-get remove --purge vsftpd

sudo userdel ftpuser
sudo groupdel ftpgroup

sudo rm -rf  /etc/vsftpd.user_list
sudo rm -rf  /home/ftp
echo 'delete success !'
