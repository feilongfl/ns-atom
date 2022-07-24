#!/usr/bin/env bash

source $1

if [ -z "${github}" ]
then
    echo "var github not set, exit..."
    exit
fi

if [ ! -z "${github_ignore}" ]
then
    echo "github ignore var is set, exit..."
    exit
fi

# check update
url="https://api.github.com/repos/${github}/releases/latest"
pkgver=$(curl ${url} | jq -r '.tag_name' | sed -e "s/^v//")

sed -i -e "s/pkgver=.*/pkgver=${pkgver}/" $1
echo $1 =\> ${pkgver}

if [ ! -z "${github_assert_jqmatcher}" ]
then
    github_assert=$(curl ${url} | jq -r ${github_assert_jqmatcher})
    sed -i -e "s/github_assert=.*/github_assert=${github_assert}/" $1
fi
