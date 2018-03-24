#!/usr/bin/env bash
# -*- encoding: utf-8 -*-

# 作業ディレクトリ
wk_dir=`dirname $0`
if [ ! -d "${wk_dir}" ];
then
  echo "ERR:${wk_dir} not exist"
  exit 1
fi

# 最新のabook.dbを取得
ab_new="${wk_dir}/abook.db"
if [ -f "${ab_new}" ];
then
  rm "${ab_new}"
fi
ab_src="${HOME}/Dropbox/App/Abook/Abook.db"
if [ ! -f "${ab_src}" ];
then
  echo "ERR:${ab_src} not exist"
  exit 1
fi
cp -p "${ab_src}" "${ab_new}"
if [ $? -ne 0 ] || [ ! -f "${ab_new}" ];
then
  echo "ERR:`basename ${ab_src}` copy failed"
  exit 1
fi

# 出力生成
output="${wk_dir}/output.txt"
if [ -f "${output}" ];
then
  rm "${output}"
fi
"${wk_dir}"/abMaint.rb > "${output}"
if [ $? -ne 0 ];
then
  echo "ERR:abMaint.rb failed"
  exit 1
elif [ ! -f "${output}" ];
then
  echo "ERR:`basename ${output}` not exist"
  exit 1
fi

# 終了
echo "==============================="
echo "OK"
echo "==============================="
exit 0
