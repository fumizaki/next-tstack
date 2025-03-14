#!/bin/sh
set -e

# マイグレーションの実行
npm run migrate

# アプリの起動
exec npm run dev