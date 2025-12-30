#!/usr/bin/env bash
# -*- encoding: utf-8 -*-

# 作業ディレクトリ
wk_dir=`dirname $0`

# 既存の sqlite3 ファイルを削除
sqlite="${wk_dir}/abook.sqlite3"
if [ -f "${sqlite}" ];
then
    rm "${sqlite}"
fi

# DBファイル存在チェック
db_file="../abook/Abook.db"
if [ ! -f "${db_file}" ];
then
  echo "ERR:Abook.db not found"
  exit 1
fi

# Abook.db -> abook.sqlite3 へ変換
export wk_dir
export sqlite
export db_file
"${wk_dir}"/to_sqlite.sh
if [ $? -ne 0 ] || [ ! -f "${sqlite}" ];
then
  echo "ERR:`basename ${sqlite}` convert failed"
  exit 1
fi

# 帳票を出力
summary_pdf="${wk_dir}/summary.pdf"
balance_pdf="${wk_dir}/balance.pdf"
"${wk_dir}"/report.rb
if [ $? -ne 0 ];
then
  echo "ERR:report.rb failed"
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
