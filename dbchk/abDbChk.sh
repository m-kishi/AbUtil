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

# チェック実行
export db_file
"${wk_dir}"/abDbchk.rb
if [ $? -ne 0 ];
then
  echo "ERR:abDbchk failed"
  exit 1
fi

# 終了
exit 0
