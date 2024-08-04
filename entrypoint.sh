#!/bin/sh

set -e

CONFIG_FILE=${1:-"/sync-repos.yml"}
DRY_RUN=${2:-"false"}

# SSH 设置
if [ -n "$SSH_PRIVATE_KEY" ]
then
  mkdir -p /root/.ssh
  echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
fi

if [ -n "$SSH_KNOWN_HOSTS" ]
then
  mkdir -p /root/.ssh
  echo "StrictHostKeyChecking yes" >> /etc/ssh/ssh_config
  echo "$SSH_KNOWN_HOSTS" > /root/.ssh/known_hosts
  chmod 600 /root/.ssh/known_hosts
else
  echo "WARNING: StrictHostKeyChecking disabled"
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
fi

mkdir -p ~/.ssh
cp /root/.ssh/* ~/.ssh/ 2> /dev/null || true

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found!"
    exit 1
fi

# 遍历配置文件中的仓库列表
sed -n '/^  - src:/,/^  - src:/p' "$CONFIG_FILE" | while read -r line; do
  case "$line" in
    *src:*)
      SRC=$(echo "$line" | sed 's/.*src: *"\(.*\)".*/\1/')
      ;;
    *dst:*)
      DST=$(echo "$line" | sed 's/.*dst: *"\(.*\)".*/\1/')
      if [ -n "$SRC" ] && [ -n "$DST" ]; then
        echo "Syncing $SRC to $DST"
        /git-mirror.sh "$SRC" "$DST" "$DRY_RUN"
        echo "Sync completed for $SRC"
      fi
      SRC=""
      DST=""
      ;;
  esac
done

echo "All repositories synced successfully"