#!/bin/sh
export LANG=zh_CN.UTF-8

if [ -f /etc/profile ]; then
  source /etc/profile
fi
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi
if [ -f /root/.bash_profile ]; then
  source /root/.bash_profile
fi
if [ -f /root/.bashrc ]; then
  source /root/.bashrc
fi

curDate=`date +%Y%m%d%H%M%S`
dirname $0 | grep "^/" > /dev/null
if [ $? -eq 0 ]; then  
  installFileDir=`dirname $0`
else  
  installFileDir=$(cd "$(dirname "$0")"; pwd)
fi
servicename=demoTest
dos2unix "$installFileDir"/VERSION
VERSION=`head -n 1 "$installFileDir"/VERSION`

deployDir=/demo/core/"$servicename"

# 依赖库文件
mkdir -p "$deployDir"/lib
if [ -d "$installFileDir"/lib ]; then
  \rm -f "$deployDir"/lib/*
  \cp -rf "$installFileDir"/lib/* "$deployDir"/lib
fi
# 配置文件
mkdir -p "$deployDir"/etc

# jar文件
rm -rf "$deployDir"/bin/
mkdir -p "$deployDir"/bin/
\cp -rf "$installFileDir"/bin/* "$deployDir"/bin

# 服务文件
\cp -f $installFileDir/service/$servicename /etc/init.d/$servicename
chmod 777  /etc/init.d/$servicename

# 日志文件
mkdir -p /demo/log/$servicename

# 增加到系统启动项
chkconfig --del $servicename
chkconfig --add $servicename

# 修改版本记录
echo "$VERSION" > "$deployDir"/VERSION
echo "$VERSION install at $curDate" >> "$deployDir"/VERSIONS

# 修改文件权限
chown -R test:test "$deployDir"
chown test:test /demo/log/$servicename

# 重启服务
/etc/init.d/$servicename restart

echo "安装完成，当前$servicename版本:$VERSION"

