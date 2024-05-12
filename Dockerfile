# ==============================
# AbUtil の開発環境イメージ
# ==============================
# ubuntu 20.04 LTS
FROM ubuntu:20.04

# 作業用フォルダ
WORKDIR /AbUtil

# rvm インストール
RUN apt update
RUN apt -y install curl gnupg2
RUN gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN . /etc/profile.d/rvm.sh
RUN echo 'source /etc/profile.d/rvm.sh' >> ${HOME}/.bashrc

# 日本語の設定
RUN apt install -y locales
RUN locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja

# イメージの作成
# docker build -t abutil:1.0 .

# イメージからコンテナを生成
# docker run -d -it --name abutil -v ~/Programs/AbUtil:/AbUtil -d abutil:1.0
#   -d     : デタッチ(バックグラウンドで動作)
#   -it    : このオプションがないとコンテナを起動してもすぐに終了してしまう
#   --name : コンテナ名称
#   -v     : ホストの ~/Programs/AbUtil をコンテナの /AbUtil へマウント

# Ruby インストール
# バージョン一覧
# rvm list known
# インストール
# rvm install ruby-3

# デフォルトバージョンに設定
# rvm use 3.0.0 --default
# 確認
# ruby -v

# gemset の作成
# rvm gemset create AbUtil
# rvm 3.0@AbUtil
# 確認
# rvm gemset list
