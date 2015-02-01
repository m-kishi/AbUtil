#!/usr/bin/env bash

#Gemセット
#$ gem install sqlite3 thinreports --no-ri --no-rdoc
source "${HOME}/.rvm/scripts/rvm"
rvm 2.1@AbUtil

#作業ディレクトリ
wk_dir=`dirname $0`
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
summary_pdf="${wk_dir}/summary.pdf"
balance_pdf="${wk_dir}/balance.pdf"
"${wk_dir}"/abReport.rb
if [ $? -ne 0 ];
then
  echo "ERR : abReport.rb failed"
  exit 1
elif [ ! -f "${summary_pdf}" ];
then
  echo "ERR : `basename ${summary_pdf}` not exist"
  exit 1
elif [ ! -f "${balance_pdf}" ];
then
  echo "ERR : `basename ${balance_pdf}` not exist"
  exit 1
fi
echo "INF : `basename ${summary_pdf}` printed"
echo "INF : `basename ${balance_pdf}` printed"

#帳票を表示
open "${summary_pdf}"
open "${balance_pdf}"

#終了
exit 0
