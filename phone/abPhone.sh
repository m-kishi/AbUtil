#!/usr/bin/env bash
# -*- encoding: utf-8 -*-

# 作業ディレクトリ
wk_dir=`dirname $0`

# DBファイル存在チェック
db_file="../abook/Abook.db"
if [ ! -f "${db_file}" ];
then
  echo "ERR:Abook.db not found"
  exit 1
fi

export db_file
html="${wk_dir}/Abook.html"
"${wk_dir}"/abPhone.rb > "${html}"
if [ $? -ne 0 ];
then
  echo "ERR:abPhone.rb failed"
  exit 1
elif [ ! -f "${html}" ];
then
  echo "ERR:`basename ${html}` not exist"
  exit 1
fi