#!/usr/bin/env bash

echo build $1

sudo chown -R nobody:nobody .
sudo -u nobody make VERSION=$1
sudo chown -R root:root .
