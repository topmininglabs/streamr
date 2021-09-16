#!/bin/bash

#docker环境安装
install_docker(){
        docker_check=`docker version | grep Engine | wc -l`
        if [ ${docker_check} = "0" ]; then
            echo "-----------------------------------------------------"
            echo "开始使用Docker官方脚本部署Docker!"
            read -p "当前版本是否为CentOS8版本(输入Y或N): " if_CentOS8
                if [ ${if_CentOS8} = "Y" -o ${if_CentOS8} = "y" ]; then
                        echo T | sudo yum remove containerd.io
                        sudo yum install -y yum-utils
                        sudo yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
                        echo Y | sudo yum install docker-ce docker-ce-cli -y --nobest
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        sudo docker version
                else
                    curl -fsSL https://get.docker.com -o get-docker.sh
                    sh get-docker.sh
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    sudo docker version
            fi
        else
            echo "-----------------------------------------------------"
            echo "Docker已安装，无需操作!"
        fi
}

#下载镜像
downloadd_tpm_image() {
            echo "-----------------------------------------------------"
            echo "开始下载/更新TopMininG专供streamr最新镜像: "
            docker pull topmininglabs/streamr-image:latest
            echo "-----------------------------------------------------"
            docker image ls
            image_count=`docker image ls | grep topmininglabs/streamr-image | wc -l`
            if [ ${image_count} != "0" ]; then
                echo "-----------------------------------------------------"
                echo "TopMininG专供streamr最新镜像已下载/更新完成!"
            else
                echo "-----------------------------------------------------"
                echo "镜像下载失败，请确认网络连接正常且正确安装Docker后再重试！"
                all
            fi
}

#部署节点
run_node(){
        echo "-----------------------------------------------------"
        read -p "请输入streamr节点初始编号[默认:1]: " node_start
        node_start=${node_start:=1}
        read -p "请输入要部署的streamr节点数[默认:3]: " node_count
        node_count=${node_count:=3}
        read -p "请输入本地机器映射到streamr容器节点的RPC起始端口[每个节点需3个端口，默认:7170/7171/7172]: " port
        port=${port:=7170}
        for ((i=$node_start , j = 0; i<=$node_start + node_count - 1; i ++ , j ++))
        do
                echo "-----------------------------------------------------"
                str1="开始部署节点topmining_streamr_"
                str2=${i}
                echo ${str1}${str2}
                mkdir ~/.streamrDocker${i}
                echo "按提示输入ETH地址私钥，及相关设置!"
                echo "================================"
                echo "----------以下为设置向导----------"
                echo "================================"
                echo "按提示输入ETH地址私钥，及相关设置!" 
                echo "每个节点需要独立的ETH地址私钥!"                
                echo "创建ETH私钥：选create"
                echo "导入ETH私钥：选import"
                echo "输入a选择全部导入"
                echo "所有端口：输入回车即可"
                echo "配置文件目录：输入回车即可"
                echo "================================"
                docker run -it --rm -v $(cd ~/.streamrDocker${i}; pwd):/root/.streamr --name streamr-node${i} topmininglabs/streamr-image:latest bin/config-wizard
                sleep 2
                p1=${port} + j * 3
                p2=${port} + j * 3 + 1
                p3=${port} + j * 3 + 2
                docker run -itd --restart always -p ${p1}:7170 -p ${p2}:7171 -p ${p3}:1883 -v $(cd ~/.streamrDocker${i}; pwd):/root/.streamr --name streamr-node${i} topmininglabs/streamr-image:latest
                echo "成功部署节点topmining_streamr_${i}!"
                sleep 1
        done
        echo "TopMininG专供streamr节点部署成功!"
        echo "-----------------------------------------------------"
}

#查询节点运行状态
check_node_status() {
        node_count=`docker ps --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count} = "1" ]; then
                echo "-----------------------------------------------------"
            echo "尚未部署TopMininG专供streamr节点,请部署后再执行此操作!"
            all
        else
                echo "-----------------------------------------------------"
                echo "当前TopMininG专供streamr节点运行状态如下: "
                docker ps --filter="name=topmining_streamr_"
        fi
}

#打印单个节点日志
check_logs_single() {
        node_count=`docker ps --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count} = "1" ]; then
                echo "-----------------------------------------------------"
            echo "尚未部署TopMininG专供streamr节点,请部署后再执行此操作!"
            all
        else
                echo "-----------------------------------------------------"
                read -p "请输入要查看的streamr节点序号: " node_number
                read -p "请输入要查看的日志行数: " col_number
                str1="开始查询节点topmining_streamr_"
                str2=${node_number}
                str3="日志: "
                echo $str1${str2}$str3
                docker logs --tail ${col_number} topmining_streamr_${node_number} 
        fi
}

#打印所有节点日志
check_logs_all() {
        node_count=`docker ps --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count} = "1" ]; then
                echo "-----------------------------------------------------"
            echo "尚未部署TopMininG专供streamr节点,请部署后再执行此操作!"
            all
        else
                read -p "请输入要查看的日志行数: " col_number
                read -p "请输入streamr节点初始编号[默认:1]: " node_start
                node_start=${node_start:=1}
                for ((i=$node_start; i<=$node_start + node_count - 1; i ++))
                do
                echo "-----------------------------------------------------"
                        str1="开始查询节点topmining_streamr_"
                        str2=${i}
                        str3="日志: "
                        echo ${str1}${str2}${str3}
                docker logs --tail ${col_number} topmining_streamr_${i} 
                sleep 1
                done
        fi
}

#重启单个节点
restart_node_single(){
        node_count=`docker ps --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count} = "1" ]; then
                echo "-----------------------------------------------------"
            echo "尚未部署TopMininG专供streamr节点,请部署后再执行此操作!"
            all
        else
                echo "-----------------------------------------------------"
                read -p "请输入要重启的streamr节点序号: " node_number
                str1="开始重启节点topmining_streamr_"
                str2=${node_number}
                str3=": "
                echo $str1${str2}$str3
                docker restart topmining_streamr_${node_number} 
                echo "TopMininG专供streamr节点重启成功!"
        fi
}

#重启所有节点
restart_node_all(){
        node_count=`docker ps --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count} = "1" ]; then
                echo "-----------------------------------------------------"
            echo "尚未部署TopMininG专供streamr节点,请部署后再执行此操作!"
            all
        else
        docker restart $(docker ps -qa -f name=topmining_streamr_)
        echo "-----------------------------------------------------"
        echo "TopMininG专供streamr节点重启成功!"
    fi
}

#更新节点
update_node_all(){
        node_count1=`docker ps -a --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count1} = "1" ]; then
                echo "-----------------------------------------------------"
            echo "未部署TopMininG专供streamr节点,无需更新!"
            all
        else
                echo "-----------------------------------------------------"
                echo "当前运行中的TopMininG专供streamr节点为: "
                docker ps --filter="name=topmining_streamr_"
                node_count2=`docker ps --filter="name=topmining_streamr_" | wc -l`
                read -p "是否确认更新所有streamr节点(输入Y开始删除，输入N取消删除): " delete_node
                if [ ${delete_node} = "Y" -o ${delete_node} = "y" ]; then
                	read -p "请输入streamr节点初始编号[默认:1]: " node_start
                	node_start=${node_start:=1}
                        for ((i=$node_start; i<=$node_start + node_count2 - 1; i ++))
                        do
                    echo "-----------------------------------------------------"
                    str1="开始更新streamr节点topmining_streamr_"
                    str2=${i}
                    str3="： "
                    echo ${str1}${str2}${str3}
                    docker run --rm -v  /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --run-once topmining_streamr_${i}
                    str4="streamr节点topmining_streamr_"
                    str5=${i}
                    str6="已成功更新!"
                    echo ${str4}${str5}${str6}
                done 
                echo "已成功更新通过此脚本部署的所有streamr节点!"
                docker ps
            else all
            fi
        fi
}

#删除节点
delete_node_all() {
        node_count1=`docker ps -a --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count1} = "1" ]; then
        echo "-----------------------------------------------------"
        echo "未部署TopMininG专供streamr节点,无需删除!"
        all
        else
                echo "-----------------------------------------------------"
                echo "当前运行中的TopMininG专供streamr节点为: "
                docker ps --filter="name=topmining_streamr_"
                read -p "是否确认彻底删除streamr节点(输入Y开始删除，输入N取消删除): " delete_node
                if [ ${delete_node} = "Y" -o ${delete_node} = "y" ]; then
                echo "-----------------------------------------------------"
                echo "开始删除streamr节点:"
                docker stop $(docker ps -qa -f name=topmining_streamr_)
                docker rm $(docker ps -qa -f name=topmining_streamr_)
                echo "已彻底删除通过此脚本部署的全部streamr节点!"
                docker ps
                else all
                fi
        fi
}

#删除镜像
delete_tpm_image() {
        node_count1=`docker ps -a --filter="name=topmining_streamr_" | wc -l`
        if [ ${node_count1} != "1" ]; then
                echo "-----------------------------------------------------"
            echo "以下TopMininG专供streamr节点尚未删除，请先删除节点后再执行镜像删除操作!"
            docker ps -a --filter="name=topmining_streamr_"
            all
        else
                echo "-----------------------------------------------------"
                echo "当前运行中的Docker镜像文件为: "
                docker image ls
                image_count=`docker image ls | grep topmininglabs/streamr-image | wc -l`
                if [ ${image_count} = "0" ]; then
                        echo "-----------------------------------------------------"
                echo "尚未下载TopMininG专供镜像，无需执行次操作!"
                exit 1
            else
                read -p "是否确认彻底删除通过此脚本下载的TopMininG专供streamr镜像(输入Y开始删除，输入N取消删除): " delete_image
                if [ ${delete_image} = "Y" -o ${delete_image} = "y" ]; then
                                echo "-----------------------------------------------------"
                        echo "开始删除TopMininG专供streamr镜像: "
                        docker rmi topmininglabs/streamr-image:latest
                        echo "已彻底删除TopMininG专供streamr镜像!"
                        docker image ls
                else
                        exit 1
                fi
            fi
        fi
}
all(){
while true 
        do
cat << EOF
-----------------------------------------------------
    _____           __  __ _       _        ____
   |_   _|__  _ __ |  \/  (_)_ __ (_)_ __  / ___|
     | |/ _ \| '_ \| |\/| | | '_ \| | '_ \| |  _
     | | (_) | |_) | |  | | | | | | | | | | |_| |
     |_|\___/| .__/|_|  |_|_|_| |_|_|_| |_|\____|
             |_|
  --------------------------------------------------  
           此脚本为TogMininG社区成员编写
          联系方式:https://topmining.io/
  --------------------------------------------------  

(1) 安装docker环境
(2) 下载/更新TopMininG专供streamr最新镜像
(3) 部署并启动streamr节点
(4) 检查通过此脚本创建的streamr节点运行状态
(5) 查看通过此脚本创建的单个streamr节点运行日志
(6) 查看通过此脚本创建的所有streamr节点运行日志
(7) 重启单个streamr节点
(8) 重启所有streamr节点
(9) 更新通过此脚本部署的所有streamr节点
(10) 删除通过此脚本部署的所有streamr节点
(11) 删除streamr镜像
(0) exit
EOF
        read -p "请输入要执行的选项: " input
        case $input in
                1)
                        install_docker
                        ;;
                2)
                        downloadd_tpm_image
                        ;;
                3)
                        run_node
                        ;;
                4)
                        check_node_status
                        ;;
                5)
                        check_logs_single
                        ;;
                6)
                        check_logs_all
                        ;;                       
                7)
                        restart_node_single
                        ;;                         
                8)
                        restart_node_all
                        ;;
                9)
                        update_node_all
                        ;;  
                10)
                        delete_node_all
                        ;;
                11)
                        delete_tpm_image
                        ;;               
                0)
                        exit
                        ;;
        esac

done
}
while true
do
cat << EOF
-----------------------------------------------------
    _____           __  __ _       _        ____
   |_   _|__  _ __ |  \/  (_)_ __ (_)_ __  / ___|
     | |/ _ \| '_ \| |\/| | | '_ \| | '_ \| |  _
     | | (_) | |_) | |  | | | | | | | | | | |_| |
     |_|\___/| .__/|_|  |_|_|_| |_|_|_| |_|\____|
             |_|
  --------------------------------------------------  
           此脚本为TogMininG社区成员编写
          联系方式:https://topmining.io/
  --------------------------------------------------  

(1) 安装docker环境
(2) 下载/更新TopMininG专供streamr最新镜像
(3) 部署并启动streamr节点
(4) 检查通过此脚本创建的streamr节点运行状态
(5) 查看通过此脚本创建的单个streamr节点运行日志
(6) 查看通过此脚本创建的所有streamr节点运行日志
(7) 重启单个streamr节点
(8) 重启所有streamr节点
(9) 更新通过此脚本部署的所有streamr节点
(10) 删除通过此脚本部署的所有streamr节点
(11) 删除streamr镜像
(0) exit
EOF
        read -p "请输入要执行的选项: " input
        case $input in
                1)
                        install_docker
                        ;;
                2)
                        downloadd_tpm_image
                        ;;
                3)
                        run_node
                        ;;
                4)
                        check_node_status
                        ;;
                5)
                        check_logs_single
                        ;;
                6)
                        check_logs_all
                        ;;                       
                7)
                        restart_node_single
                        ;;                         
                8)
                        restart_node_all
                        ;;
                9)
                        update_node_all
                        ;;  
                10)
                        delete_node_all
                        ;;
                11)
                        delete_tpm_image
                        ;;               
                0)
                        exit
                        ;;
        esac

done

