rem 生成安装包
call mvn clean package -P dev -Dmaven.test.skip=true deploy 
pause
