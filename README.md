## streamr测试网v2.0 docker一键部署脚本（Ubuntu&CentOS）（支持多节点部署）
### ===本脚本仅限TopMininG社群用户使用===
#### ■ 一键脚本运行方法(整行复制粘贴执行)：
  
#### @国内用户：
##### ・Ubuntu：
##### ___`sudo apt update && sudo apt-get install wget curl`___
##### ・CentOS7：
##### ___`sudo yum update && sudo yum install wget curl`___
##### ・CentOS8：
##### ___`sudo yum update --nobest && sudo yum install wget curl`___
##### 
##### ___`wget https://gitee.com/topmininglabs/streamr/raw/main/topmining_streamr.sh.x && chmod +x ./topmining_streamr.sh.x && sudo ./topmining_streamr.sh.x`___
  
#### @海外用户：
##### ・Ubuntu：
##### ___`sudo apt update && sudo apt-get install wget curl`___
##### ・CentOS7：
##### ___`sudo yum update && sudo yum install wget curl`___
##### ・CentOS8：
##### ___`sudo yum update --nobest && sudo yum install wget curl`___
##### 
##### ___`wget https://github.com/topmininglabs/streamr/raw/main/topmining_streamr.sh.x && chmod +x ./topmining_streamr.sh.x && sudo ./topmining_streamr.sh.x`___
#####   

#### ■ 操作方法：
<img width="379" alt="スクリーンショット 2021-09-16 11 08 21" src="https://user-images.githubusercontent.com/86814869/133537735-0fbf7489-2468-450f-9110-2fa7f31ae173.png">

#### ■ 注意事项
##### 1：此脚本仅支持Ubuntu系统和CentOS系统
##### 2：运行脚本安装Docker并下载TopMininG专供镜像进行节点部署（TopMininG专供镜像为官方编译的纯净打包版无任何修改可放心使用） 
##### 3：如因系统防火墙或云服务防火墙原因无法用次脚本下载安装Docker，请自行咨询服务商了解相应的Docker安装方法并手动安装Docker
##### 4：非TopMininG专供镜像部署的节点运行此脚本无效（TopMininG专供镜像为官方编译的纯净打包版无任何修改可放心使用） 
##### 5：Ubuntu系统需先执行sudo apt update 确保系统软件依赖包为最新
##### 6：Centos系统需先执行sudo yum update 确保系统软件依赖包为最新


#### ■ 常用链接：  
##### 1.streamr官网：https://streamr.network/
##### 2.streamr区块浏览器：https://streamr.network/network-explorer/nodes.com
##### 3.streamr官方水龙头：暂未公布细节
##### 4.streamr官方Gitlab：https://github.com/streamr-dev
##### 5.streamr官方文档：https://streamr.network/docs/getting-started
##### 6.streamr路线图（Milestone）：暂未公布细节
##### 7.streamr测试网奖励说明：https://medium.com/streamrblog/how-to-join-the-brubeck-testnet-c8b823c847f8
##### 8.streamr官方推特：https://twitter.com/streamr
##### 9.streamr官方Discord群：https://discord.gg/gZAm8P7hK8



