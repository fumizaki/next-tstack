.PHONY: init docker-up docker-down docker-free

# デフォルトの環境を local に設定
ENV ?= local

# rootの.envファイル作成
create_root_env:
	@if [ ! -f ./.env.example ]; then \
		echo "WEBVIEW_ENV=local" > ./.env.example; \
		echo "WEBVIEW_PORT=3000" > ./.env.example; \
		echo "WEBVIEW_BASE_URL=http://localhost:${WEBVIEW_PORT}" > ./.env.example; \
	fi
	@if [ ! -f ./.env ]; then \
		cp -f ./.env.example ./.env; \
	fi

# 初期セットアップコマンド
init: create_root_env

# Dockerコンテナ起動
docker-up:
	docker compose -f compose.${ENV}.yml up -d --build

# Dockerコンテナ削除
docker-down:
	docker compose -f compose.${ENV}.yml down --rmi all

# Dockerメモリ解放
docker-free:
	docker system prune