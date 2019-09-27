#!/bin/bash

#change port

sudo 'listen_port'

sudo apt-get install vsftpd

#add user list
sudo touch /etc/vsftpd.user_list
echo 'admin'>>/etc/vsftpd.user_list
echo 'ftpuser'>>/etc/vsftpd.user_list


#write config
echo 'anonymous_enable=YES'>>/etc/vsftpd.conf
echo 'local_enable=YES'>>/etc/vsftpd.conf
echo 'write_enable=YES'>>/etc/vsftpd.conf
echo 'userlist_file=/etc/vsftpd.user_list'>>/etc/vsftpd.conf
echo 'userlist_enable=YES'>>/etc/vsftpd.conf
echo 'userlist_deny=NO'>>/etc/vsftpd.conf



#create group
sudo mkdir /home/ftp
sudo mkdir /home/ftp/ftpuser
sudo groupadd ftpgroup
sudo useradd -g ftpgroup -d /home/ftp/ftpuser -M ftpuser

echo 'add account --- in '
check_user 'admin'
if [ $? -eq 0 ]
then
        echo 'start add user admin'
        sudo useradd -g ftpgroup -d /home/ftp/ftpuser -M admin
	echo 'admin:123456'|chpasswd
fi
 
echo 'add account ---out'

echo 'ftpuser:123456'|chpasswd

sudo chmod 777 /ftp/ftpuser
sudo service vsftpd start

#sudo mkdir /home/uftp
#sudo chmod -R 777 /home/uftp

#sudo useradd -d /home/uftp -s /bin/bash uftp

#echo "please input the user password zhanghailun"

#echo '123456'>> sudo passwd uftpadmin

#sudo chown uftp:uftp /home/uftp

#sudo touch  /etc/vsftpd.user_list


#sudo echo 'admin'>>/etc/vsftpd.user_list
#sudo echo 'uftp'>>/etc/vsftpd.user_list

#sudo echo 'write_enable=YES'>>/etc/vsftpd.conf
#sudo echo 'userlist_file =/etc/vsftpd.user_list'>>/etc/vsftpd.conf
#sudo echo 'userlist_enable=YES'>>/etc/vsftpd.conf
#sudo echo 'userlist_deny=NO'>>/etc/vsftpd.conf
#echo 'anonymous_enable=NO'>>/etc/vsftpd.conf
#echo 'local_enable=YES'>>/etc/vsftpd.conf
#echo 'write_enable=YES'>>/etc/vsftpd.conf
#echo 'local_umask=022'>>/etc/vsftpd.conf
#echo 'use_localtime=YES'>>/etc/vsftpd.conf
#echo 'dirmessage_enable=NO'>>/etc/vsftpd.conf
#echo 'connect_from_port_20=YES'>>/etc/vsftpd.conf
#echo 'xferlog_enable=YES'>>/etc/vsftpd.conf
#echo 'xferlog_file=/var/log/vsftpd.log'>>/etc/vsftpd.conf
#echo 'xferlog_std_format=YES'>>/etc/vsftpd.conf
#echo 'chroot_local_user=YES'>>/etc/vsftpd.conf
#echo 'guest_enable=YES'>>/etc/vsftpd.conf
#echo 'pam_service_name=vsftpd'>>/etc/vsftpd.conf
#echo 'secure_chroot_dir=/var/run/vsftpd/empty'>>/etc/vsftpd.conf
#echo 'rsa_cert_file=/etc/ssl/private/vsftpd.pem'>>/etc/vsftpd.conf
#echo 'userlist_file =/etc/vsftpd.user_list'>>/etc/vsftpd.conf

echo "the service can restart "

sudo service  vsftpd restart

