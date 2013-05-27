#!/usr/bin/env bash

#Gemセット
#$ gem install sqlite3 thinreports --no-ri --no-rdoc
source "${HOME}/.rvm/scripts/rvm"
rvm 1.9.2@ab_maintenance

#作業ディレクトリ
wk_dir="${HOME}/code/AbUtils/print"
if [ ! -d "${wk_dir}" ];
then
  echo "ERR : ${wk_dir} not exist"
  exit 1
fi

#既存のDBファイルを削除
ab_new="${wk_dir}/abook.db"
if [ -f "${ab_new}" ];
then
  rm "${ab_new}"
  echo "INF : `basename ${ab_new}` deleted"
fi

#最新のAbook.dbを取得
ab_src="${HOME}/Dropbox/App/Abook/Abook.db"
if [ ! -f "${ab_src}" ];
then
  echo "ERR : ${ab_src} not exist"
  exit 1
fi
cp -p "${ab_src}" "${ab_new}"
if [ $? -ne 0 ] || [ ! -f "${ab_new}" ];
then
  echo "ERR : `basename ${ab_src}` copy failed"
  exit 1
fi
echo "INF : `basename ${ab_src}` copied"

#既存のsqlite3ファイルを削除
ab_sqlite="${wk_dir}/abook.sqlite3"
if [ -f "${ab_sqlite}" ];
then
    rm "${ab_sqlite}"
    echo "INF : `basename ${ab_sqlite}` deleted"
fi

#abook.db -> abook.sqlite3へ変換
export wk_dir
export ab_new
export ab_sqlite
"${wk_dir}"/abToSqlite.sh
if [ $? -ne 0 ] || [ ! -f "${ab_sqlite}" ];
then
  echo "ERR : `basename ${ab_sqlite}` convert failed"
  exit 1
fi

#帳票を出力
ab_report="${wk_dir}/abook.pdf"
"${wk_dir}"/abReport.rb
if [ $? -ne 0 ];
then
  echo "ERR : abReport.rb failed"
  exit 1
elif [ ! -f "${ab_report}" ];
then
  echo "ERR : `basename ${ab_report}` not exist"
  exit 1
fi
echo "INF : `basename ${ab_report}` printed"

#帳票を表示
open "${ab_report}"

#終了
exit 0
