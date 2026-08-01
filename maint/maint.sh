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

# 出力生成
export db_file
maint_file="${wk_dir}/maint.txt"
if [ -f "${maint_file}" ];
then
  rm "${maint_file}"
fi
"${wk_dir}"/maint.rb > "${maint_file}"
if [ $? -ne 0 ];
then
  echo "ERR:maint.rb failed"
  exit 1
elif [ ! -f "${maint_file}" ];
then
  echo "ERR:`basename ${maint_file}` not exist"
  exit 1
fi

# 終了
echo "==============================="
echo "OK"
echo "==============================="
exit 0
