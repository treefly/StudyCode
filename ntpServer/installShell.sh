#!/bin/bash

read -p "请输入软件名称：" package
pName=$(rpm -qa | grep "${package}")
if [ $? -eq 0 ]
then
    echo "软件包"${pName}"已经安装"
else
    echo "软件包"${pName}"没有安装"
       read -p "是否安装（y|n）:"  -n 1 OK
       #-n 1  表示只能输一下，输入到OK的变量
       if [ ${OK} = "y" ] || [ ${OK} = "Y" ]
       then
          echo "开始安装......."
          yum -y install ./vsftpd-3.0.2-25.el7.x86_64.rpm
          if test $? -eq 0
          then
                echo "安装"${pakcage}"完成"
          else
                echo "安装"${package}"失败"
          fi
      else
          echo "你选择放弃安装" 
  fi
fi
     
