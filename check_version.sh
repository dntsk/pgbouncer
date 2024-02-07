#!/bin/bash
set -e

new_version=$(curl -s https://www.pgbouncer.org/downloads/ | grep "tar.gz" | head -1 | awk -F- '{print $3}' | awk -F'<' '{print $1}' | awk -F. '{print $1"."$2"."$3}')
old_version=$(cat Dockerfile | grep 'PGBOUNCER_VERSION=' | awk -F= '{print $2}' | tr -d '"')


if [ "${old_version}" != "${new_version}" ]; then
	echo "Update required"
	sed "s/${old_version}/${new_version}/g" Dockerfile
fi
