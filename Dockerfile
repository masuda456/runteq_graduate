# ベースとなるDockerイメージを選択(ruby 3.1.4を使用する)
FROM ruby:3.1.4

# 言語設定を指定するための環境変数
# ENV LANG C.UTF-8(汎用性があり、国際化などの対応化)
# ENV LANG=ja_JP.UTF-8(一般的な日本語のアプリケーションで推奨されている)
ENV LANG=ja_JP.UTF-8

# コンテナ内のシステム時刻を日本標準時に設定
ENV TZ Asia/Tokyo

# Gemのインストールに必要なライブラリをインストール(Rails7では不要？)
# RUN \
# Node.jsをインストールするために実行(rails7を使用する場合は不要？)
# curl -sL https://deb.nodesource.com/setup_19.x | bash - \
# Yarnパッケージマネージャーをインストールするために必要(rails7を使用する場合は不要？)
# && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
# Yarnパッケージを公式のリポジトリから取得できるようにする(rails7を使用する場合は不要？)
# && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
# パッケージリストの更新
# apt-get update -qq \
# ビルド / DB / JavaScriptなどで必要なものをインストール(rails7を使用する場合は"node.js / yarn"は不要)
# && apt-get install -y build-essential libpq-dev nodejs yarn
# && apt-get install -y build-essential libpq-dev

# アプリケーションのルートディレクトリを作成
RUN mkdir /runteq_graduate

# 作業ディレクトリの変更(以降のコマンドが指定のディレクトリで使用される)
WORKDIR /runteq_graduate

# Bundlerのバージョン3.2.4をインストール
# RUN gem install bundler:3.2.4

# ホストマシンの"Gemfile/Gemfile.lock"を作業ディレクトリにコピー
COPY Gemfile /runteq_graduate/Gemfile
COPY Gemfile.lock /runteq_graduate/Gemfile.lock

# RubyGems / Bundlerのアップデート
RUN gem update --system
RUN bundle update --bundler

# ホストマシンの"yarn.lock"を作業ディレクトリにコピー
# 該当ファイルが存在しないため省略
# COPY yarn.lock /v3_basic_rails_basic/yarn.lock

# Gemfileからgem依存関係をインストール
RUN bundle install

# RUN gem pristine --all

# Yarnを使用してJavaScriptパッケージの依存関係をインストール
# 該当ファイルが存在しないため省略
# RUN yarn install

# カレントディレクトリのアプリケーションコード全体をコンテナの作業ディレクトリにコピー
COPY . /runteq_graduate

# コンテナ起動時にシェルスクリプトを実行する
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Railsサーバーを起動する
CMD ["rails", "server", "-b", "0.0.0.0"]
