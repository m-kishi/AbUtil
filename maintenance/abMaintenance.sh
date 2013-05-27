#!/usr/bin/env bash
# -*- encoding: utf-8 -*-

#作業ディレクトリ
wk_dir="${HOME}/code/AbUtils/maintenance"
if [ ! -d "${wk_dir}" ];
then
  echo "ERR : ${wk_dir} not exist"
  exit 1
fi

#最新のabook.dbを取得
ab_new="${wk_dir}/abook.db"
if [ -f "${ab_new}" ];
then
  rm "${ab_new}"
  echo "INF : `basename ${ab_new}` deleted"
fi
ab_src="/Users/m-kishi/Dropbox/App/Abook/Abook.db"
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

#ペアリスト生成
pairlist="${wk_dir}/pair.txt"
if [ -f "${pairlist}" ];
then
  rm "${pairlist}"
  echo "INF : `basename ${pairlist}` deleted"
fi
"${wk_dir}"/abMaintenance.rb > "${pairlist}"
if [ $? -ne 0 ];
then
  echo "ERR : abMaintenance.rb failed"
  exit 1
elif [ ! -f "${pairlist}" ];
then
  echo "ERR : `basename ${pairlist}` not exist"
  exit 1
fi
echo "INF : pairlist generated"

#終了
exit 0
