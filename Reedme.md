# laravel-blog-docker

laravel-blogの開発用環境

## セットアップ

ソースコードをクローン
```bash
git clone https://github.com/EnjoyKojima/laravel-blog.git
```

.envをコピー
```bash
cp laravel-blog/.env.example laravel-blog/.env
```

コンテナ起動
```bash
docker-compose up -d
```

コンテナに潜る
```bash
docker exec -it laravel-blog-app /bin/bash
```

パッケージをインストール
```bash
npm install
npm run build
```

アプリケーションの初期設定
```bash
php artisan key:generate
php artisan horizon:install
php artisan telescope:install
php artisan storage:link
```

