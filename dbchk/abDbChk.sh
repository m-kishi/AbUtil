#!/usr/bin/env bash

# 作業ディレクトリ
wk_dir=`dirname $0`
if [ ! -d "${wk_dir}" ];
then
  echo "ERR : ${wk_dir} not exist"
  exit 1
fi

# 既存DBファイルを削除
ab_new="${wk_dir}/abook.db"
if [ -f "${ab_new}" ];
then
  rm "${ab_new}"
  echo "INF : `basename ${ab_new}` deleted"
fi

# 最新のAbook.dbを取得
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

# チェック実行
"${wk_dir}"/abDbchk.rb
if [ $? -ne 0 ];
then
  echo "ERR : abDbchk failed"
  exit 1
fi

# 終了
exit 0
