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
output="${wk_dir}/output.txt"
if [ -f "${output}" ];
then
  rm "${output}"
fi
"${wk_dir}"/abMaint.rb > "${output}"
if [ $? -ne 0 ];
then
  echo "ERR:abMaint.rb failed"
  exit 1
elif [ ! -f "${output}" ];
then
  echo "ERR:`basename ${output}` not exist"
  exit 1
fi

# 終了
echo "==============================="
echo "OK"
echo "==============================="
exit 0
