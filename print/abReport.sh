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

# 既存の sqlite3 ファイルを削除
ab_sqlite="${wk_dir}/abook.sqlite3"
if [ -f "${ab_sqlite}" ];
then
    rm "${ab_sqlite}"
fi

# Abook.db -> abook.sqlite3 へ変換
export wk_dir
export db_file
export ab_sqlite
"${wk_dir}"/abToSqlite.sh
if [ $? -ne 0 ] || [ ! -f "${ab_sqlite}" ];
then
  echo "ERR:`basename ${ab_sqlite}` convert failed"
  exit 1
fi

# 帳票を出力
summary_pdf="${wk_dir}/summary.pdf"
balance_pdf="${wk_dir}/balance.pdf"
"${wk_dir}"/abReport.rb
if [ $? -ne 0 ];
then
  echo "ERR:abReport.rb failed"
  exit 1
elif [ ! -f "${summary_pdf}" ];
then
  echo "ERR:`basename ${summary_pdf}` not exist"
  exit 1
elif [ ! -f "${balance_pdf}" ];
then
  echo "ERR:`basename ${balance_pdf}` not exist"
  exit 1
fi

# 終了
echo "==============================="
echo "OK"
echo "==============================="
exit 0
