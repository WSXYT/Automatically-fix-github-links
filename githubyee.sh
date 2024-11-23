#!/bin/bash

# 定义变量
GITHUB520_URL="https://raw.kkgithub.com/521xueweihan/GitHub520/main/hosts"
HOSTS_FILE="/etc/hosts"
START_MARKER="# GitHub520 Host Start"
END_MARKER="# GitHub520 Host End"

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请以管理员权限运行此脚本 (使用 sudo)。"
    exit 1
fi

# 从 GitHub 获取最新的 hosts 内容
echo "正在从 GitHub 获取最新 hosts 内容..."
response=$(curl -s -w "%{http_code}" -o /tmp/github520_hosts "$GITHUB520_URL")
http_code="${response: -3}"

if [ "$http_code" -ne 200 ]; then
    echo "获取失败，HTTP 状态码: $http_code"
    exit 1
fi

content=$(cat /tmp/github520_hosts)
rm /tmp/github520_hosts

# 读取当前的 hosts 文件
echo "正在更新 hosts 文件..."
if grep -q "$START_MARKER" "$HOSTS_FILE" && grep -q "$END_MARKER" "$HOSTS_FILE"; then
    # 删除标记行和之间的内容
    sed -i "/$START_MARKER/,/$END_MARKER/d" "$HOSTS_FILE"
fi

# 将新的内容添加到 hosts 文件
{
    echo -e "\n$START_MARKER"
    echo "$content"
    echo -e "$END_MARKER\n"
} >> "$HOSTS_FILE"

echo "hosts 文件更新完成！"
