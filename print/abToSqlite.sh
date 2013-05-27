#!/usr/bin/env bash

#作業用ディレクトリ
if [ -z "${wk_dir}" ];
then
    echo "ERR : \$wk_dir not exported"
    exit 1
fi

#abook.db
if [ -z "${ab_new}" ];
then
    echo "ERR : \$ab_new not exported"
    exit 1
fi

#abook.sqlite3
if [ -z "${ab_sqlite}" ];
then
    echo "ERR : \$ab_sqlite not exported"
    exit 1
fi

#SQlite3用コマンドファイル
command="${wk_dir}/command.sql"

#BEGIN TRANSACTION
echo "BEGIN TRANSACTION;" >"${command}"

#CREATE TABLE
cat >>"${command}" <<EOF
CREATE TABLE expenses (
    "date" DATE
  , "name" TEXT
  , "type" TEXT
  , "cost" INTEGER
);
EOF

#INSERT INTO
while read line;
do
    date=`echo ${line} | awk 'BEGIN{FS=","};{print $1}' | sed -e 's/"//g'`
    name=`echo ${line} | awk 'BEGIN{FS=","};{print $2}' | sed -e 's/"//g'`
    type=`echo ${line} | awk 'BEGIN{FS=","};{print $3}' | sed -e 's/"//g'`
    cost=`echo ${line} | awk 'BEGIN{FS=","};{print $4}' | sed -e 's/"//g'`
    cat >>"${command}" <<_EOF_
INSERT INTO expenses (
    "date"
  , "name"
  , "type"
  , "cost"
) VALUES (
    '${date}'
  , '${name}'
  , '${type}'
  , '${cost}'
);
_EOF_
done <"${ab_new}"

#END TRANSACTION
echo "END TRANSACTION;" >>"${command}"

#変換実行
sqlite3 "${ab_sqlite}" < "${command}"
if [ $? -ne 0 ];
then
    echo "ERR : sqlite3 failed"
    exit 1
else
    echo "INF : sqlite3 converted"
    rm "${command}"
fi

#終了
exit 0
