#!/bin/bash

# 定义变量
GITHUB520_URL="https://raw.kkgithub.com/521xueweihan/GitHub520/main/hosts"
HOSTS_FILE="/etc/hosts"
TMP_FILE="/tmp/github520_hosts"

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请以管理员权限运行此脚本 (使用 sudo)。"
    exit 1
fi

# 从 GitHub 获取最新的 hosts 内容
echo "正在从 GitHub 获取最新 hosts 内容..."
curl -sSL "$GITHUB520_URL" -o "$TMP_FILE"

# 检查下载是否成功
if [ ! -f "$TMP_FILE" ] || [ ! -s "$TMP_FILE" ]; then
    echo "下载失败或文件为空，请检查网络或 URL: $GITHUB520_URL"
    exit 1
fi

# 确保文件中不会重复插入内容
echo "正在清理旧的 GitHub520 Host 部分..."
sed -i '/# GitHub520 Host Start/,/# GitHub520 Host End/d' "$HOSTS_FILE"

# 将新的内容追加到 hosts 文件末尾
echo "正在插入最新的 GitHub520 Host 内容..."
cat "$TMP_FILE" >> "$HOSTS_FILE"

# 删除临时文件
rm -f "$TMP_FILE"

echo "hosts 文件更新完成！"
