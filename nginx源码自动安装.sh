#!/bin/bash
#一键部署Nginx软件（Web服务器)
#一键源码安装Nginx软件 
#脚本自动安装相关软件的依赖包 
#判断yum源可用不可用
n=`yum repolist |awk '/repolist/{print $2}' | sed 's/,//'`
if [ $n -le 0 ];then
echo 'yum源不可用'
 exit
fi
if [ $n -gt 0 ];then
#安装源码编译的依赖包
 tar -xf  lnmp_soft.tar.gz
 cd lnmp_soft
 yum -y install gcc openssl-devel pcre-devel
 useradd -s /sbin/nologin nginx
#解压源码包
 tar -xf nginx-1.12.2.tar.gz
#这句话是没有作用，来搞笑的
 cd  nginx-1.12.2
#指定安装目录/功能模块等选项
 ./configure --prefix=/usr/local/nginx   --user=nginx   --group=nginx  --with-http_ssl_module  --with-stream  --with-http_stub_status_module

#make编译，生成可以执行的二进制程序文件
  make 
#make install 安装包到指定位置
  make install

yum -y install  mariadb  mariadb-server  mariadb-devel
yum -y install  php  php-mysql  php-pecl-memcache memcached
cd ~
cd lnmp_soft 
yum -y install  php-fpm-5.4.16-42.el7.x86_64.rpm
cd ~
ln -s /usr/local/nginx/sbin/nginx /sbin/
nginx
systemctl restart mariadb php-fpm 

fi 


