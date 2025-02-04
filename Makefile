.PHONY: init docker-up docker-down docker-free

# デフォルトの環境を local に設定
ENV ?= local

# rootの.envファイル作成
create_root_env:
	@if [ ! -f ./.env.example ]; then \
		echo "WEBVIEW_PORT=3000" > ./.env.example; \
	fi
	@if [ ! -f ./.env ]; then \
		cp -f ./.env.example ./.env; \
	fi

# webviewの.envファイル作成
create_webview_env:
	@if [ ! -f ./app/webview/.env.example ]; then \
		echo "NODE_ENV=local" > ./app/webview/.env.example; \
	fi
	@if [ ! -f ./app/webview/.env.local ]; then \
		cp -f ./app/webview/.env.example ./app/webview/.env.local; \
	fi
	@if [ ! -f ./app/webview/.env.test ]; then \
		cp -f ./app/webview/.env.example ./app/webview/.env.test; \
	fi


# 初期セットアップコマンド
init: create_root_env create_webview_env

# Dockerコンテナ起動
docker-up:
	docker compose -f compose.${ENV}.yml up -d --build

# Dockerコンテナ削除
docker-down:
	docker compose -f compose.${ENV}.yml down --rmi all

# Dockerメモリ解放
docker-free:
	docker system prune