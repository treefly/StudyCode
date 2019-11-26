#!/bin/bash

function check_user()
{
   #判断用户是否存在在passwd中
  i=`cat /etc/passwd | cut -f1 -d':' |grep -w "$1" -c`
  if [ $i -le 0 ]
  then
          echo 'add user'
          return 0
  else
          #echo 'user admin is in the passwd'
          return 1
  fi
}

function check_directory()
{
   if [ ! -d "$1" ];
   then
           echo 'create directory'
           sudo mkdir $1
           #echo "create dirctory $1 success"
   else
           #echo "directory $1 exists"
           echo "......"
   fi
}

function editVsftpdConfig()
{
   #add user list
   #sudo touch /etc/vsftpd.user_list
   echo 'admin'>>/etc/vsftpd/user_list
   #echo 'ftpuser'>>/etc/vsftpd/user_list


   #write config
   echo 'anonymous_enable=YES'>>/etc/vsftpd/vsftpd.conf
   echo 'local_enable=YES'>>/etc/vsftpd/vsftpd.conf
   echo 'write_enable=YES'>>/etc/vsftpd/vsftpd.conf
   echo 'userlist_file=/etc/vsftpd/user_list'>>/etc/vsftpd/vsftpd.conf
   echo 'userlist_enable=YES'>>/etc/vsftpd/vsftpd.conf
   echo 'userlist_deny=NO'>>/etc/vsftpd/vsftpd.conf
   echo 'local_root=/home/ftp/ftpuser'>>/etc/vsftpd/vsftpd.conf
   echo 'tcp_wrappers=YES'>>/etc/vsftpd/vsftpd.conf
   echo 'use_localtime=YES'>>/etc/vsftpd/vsftpd.conf
}

function addAccount()
{
  #create group
  ftprootd="/home/ftp"
  ftpChild="${ftprootd}/video"

  check_directory $ftprootd
  check_directory $ftpChild

  sudo groupadd ftpgroup
  sudo useradd -g ftpgroup -d $ftpChild ftpuser

  echo 'add account --- in '
  check_user 'admin'
  if [ $? -eq 0 ]
  then
        echo 'start add user admin'
        sudo useradd -g ftpgroup -d $ftpChild admin
        echo 'admin:123456'|chpasswd
  fi
   #赋予用户访问权限
  #chown -R /home/ftp/ftpuser
  echo 'ftpuser:123456'|chpasswd
  sudo chmod 777 $ftpChild
}


function closeFirewalldService()
{
   sudo systemctl stop firewalld
   sudo systemctl disable firewalld
}


function editOtherSetting()
{
  sudo setsebool ftpd_full_access=1
  sudo setsebool ftpd_connect_all_unreserved=1
  sudo setsebool ftpd_anon_write=1
  #sudo setsebool tftpd_home_dir=1
}


pName=$(rpm -qa | grep "vsftpd")
if [ $? = 0 ]
then
   echo "vsftpd 已经安装!"
else
   echo "开始准备安装 vsftpd"
   #sudo yum -y install vsftpd
   yum -y install ./vsftpd-3.0.2-25.el7.x86_64.rpm
   editVsftpdConfig
   addAccount
   closeFirewalldService
   editOtherSetting
fi

sudo systemctl restart vsftpd
sudo systemctl enable vsftpd.service




