FROM ruby:3.2.2
ARG RUBYGEMS_VERSION=3.3.20

WORKDIR /app

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y nodejs

# ホストのGemfileをコンテナ内の作業ディレクトリにコピー
COPY Gemfile Gemfile.lock /app/

# bundle installを実行
RUN gem install bundler -v 2.5.10
RUN bundle install

# ホストのファイルをコンテナ内の作業ディレクトリにコピー
COPY . /app/

# entrypoint.shをコンテナ内の作業ディレクトリにコピー
COPY entrypoint.sh /usr/bin/

# entrypoint.shの実行権限を付与
RUN chmod +x /usr/bin/entrypoint.sh

# コンテナ起動時にentrypoint.shを実行するように設定
ENTRYPOINT ["entrypoint.sh"]

# コンテナ起動時に実行するコマンドを指定
CMD ["rails", "server", "-b", "0.0.0.0"]
