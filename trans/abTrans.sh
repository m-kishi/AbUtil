#!/usr/bin/env bash
# -*- encoding: utf-8 -*-

# 作業ディレクトリ
wk_dir=`dirname $0`
if [ ! -d "${wk_dir}" ];
then
  echo "ERR : ${wk_dir} not exist"
  exit 1
fi

# 最新のabook.dbを取得
ab_new="${wk_dir}/abook.db"
if [ -f "${ab_new}" ];
then
  rm "${ab_new}"
  echo "INF : `basename ${ab_new}` deleted"
fi
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

# 出力生成
trans="${wk_dir}/trans.db"
if [ -f "${trans}" ];
then
  rm "${trans}"
  echo "INF : `basename ${trans}` deleted"
fi
"${wk_dir}"/abTrans.rb > "${trans}"
if [ $? -ne 0 ];
then
  echo "ERR : abTrans.rb failed"
  exit 1
elif [ ! -f "${trans}" ];
then
  echo "ERR : `basename ${trans}` not exist"
  exit 1
fi
echo "INF : translation completed"

# 終了
exit 0
