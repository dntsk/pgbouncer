#!/bin/bash
set -e

new_version=$(curl -s https://www.pgbouncer.org/downloads/ | grep tar.gz | head -1 | awk -F- '{print $3}' | awk -F'<' '{print $1}' | awk -F. '{print $1"."$2"."$3}')
old_version=$(cat Dockerfile | grep pgbouncer.github.io | awk -F/ '{print $6}')

if [ "${old_version}" != "${new_version}" ]; then
	echo "Update required"
	sed -i "s/${old_version}/${new_version}/g" Dockerfile
fi
