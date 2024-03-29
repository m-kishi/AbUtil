#!/usr/bin/env bash
# -*- encoding: utf-8 -*-

# 作業用ディレクトリ
if [ -z "${wk_dir}" ];
then
  echo "ERR:\$wk_dir not exported"
  exit 1
fi

# Abook.db
if [ -z "${db_file}" ];
then
  echo "ERR:\$db_file not exported"
  exit 1
fi

# abook.sqlite3
if [ -z "${ab_sqlite}" ];
then
  echo "ERR:\$ab_sqlite not exported"
  exit 1
fi

# SQlite3用コマンドファイル
command="${wk_dir}/command.sql"
export command

# BEGIN TRANSACTION
echo "BEGIN TRANSACTION;" >"${command}"

# CREATE TABLE
cat >>"${command}" <<EOF
CREATE TABLE expenses (
    "date" DATE
  , "name" TEXT
  , "type" TEXT
  , "cost" INTEGER
);
EOF

# INSERT
"${wk_dir}"/abToSqlite.rb
if [ $? -ne 0 ];
then
  echo "ERR:abToSqlite.rb aborted"
  exit 1
fi

# END TRANSACTION
echo "END TRANSACTION;" >>"${command}"

# 変換実行
sqlite3 "${ab_sqlite}" < "${command}"
if [ $? -ne 0 ];
then
  echo "ERR:sqlite3 failed"
  exit 1
else
  rm "${command}"
fi

#終了
exit 0
