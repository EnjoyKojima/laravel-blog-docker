# ベースイメージの指定
FROM php:8.3-fpm

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    nodejs \
    npm \
    default-mysql-client \
    --fix-missing

# PHP拡張のインストール
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip mysqli

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 作業ディレクトリの設定
WORKDIR /var/www/html

# アプリケーションのソースコードをコピー
COPY ./laravel-blog .

# Composerの依存関係をインストール
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install

# npmパッケージをインストール
RUN npm install

# 必要なディレクトリを作成
RUN mkdir -p storage bootstrap/cache

# 必要なディレクトリの権限を設定
RUN chown -R www-data:www-data \
    storage \
    bootstrap/cache

# Composerのオートローダーを最適化
RUN composer dump-autoload --optimize

# アプリケーションキーの生成
RUN php artisan key:generate
# Horizonのインストール
RUN php artisan horizon:install
# Telescopeのインストール
RUN php artisan telescope:install
# ストレージリンクの作成
RUN php artisan storage:link

# アセットのビルド
RUN npm run build

# ポートの公開
EXPOSE 3000

# PHPサーバーの起動
CMD ["php-fpm"]