.PHONY: init docker-up docker-down docker-free

# デフォルトの環境を local に設定
ENV ?= local

# rootの.envファイル作成
create_root_env:
	@if [ ! -f ./.env.example ]; then \
		echo "WEBVIEW_ENV=local" > ./.env.example; \
		echo "WEBVIEW_PORT=3000" >> ./.env.example; \
		echo "WEBVIEW_BASE_URL=http://localhost:\$${WEBVIEW_PORT}" >> ./.env.example; \
		echo "RDB_HOST=rdb" >> ./.env.example; \
		echo "RDB_NAME=psql" >> ./.env.example; \
		echo "RDB_USER=psql" >> ./.env.example; \
		echo "RDB_PASSWORD=psql" >> ./.env.example; \
		echo "RDB_PORT=5432" >> ./.env.example; \
	fi
	@if [ ! -f ./.env ]; then \
		cp -f ./.env.example ./.env; \
	fi
	@echo "create_root_env done"

# webviewの.envファイル作成
create_webview_env:
	@if [ ! -f ./app/webview/.env.example ]; then \
		echo "WEBVIEW_ENV=local" > ./app/webview/.env.example; \
		echo "WEBVIEW_PORT=3000" >> ./app/webview/.env.example; \
		echo "NEXT_PUBLIC_WEBVIEW_BASE_URL=http://localhost:\$${WEBVIEW_PORT}" >> ./app/webview/.env.example; \
		echo "RDB_HOST=rdb" >> ./app/webview/.env.example; \
		echo "RDB_NAME=psql" >> ./app/webview/.env.example; \
		echo "RDB_USER=psql" >> ./app/webview/.env.example; \
		echo "RDB_PASSWORD=psql" >> ./app/webview/.env.example; \
		echo "RDB_PORT=5432" >> ./app/webview/.env.example; \
		echo "PSQL_URL=postgresql://\$${RDB_USER}:\$${RDB_PASSWORD}@\$${RDB_HOST}:\$${RDB_PORT}/\$${RDB_NAME}" >> ./.env.example; \
	fi
	@if [ ! -f ./app/webview/.env.local ]; then \
		cp -f ./app/webview/.env.example ./app/webview/.env.local; \
	fi
	@if [ ! -f ./app/webview/.env.test ]; then \
		cp -f ./app/webview/.env.example ./app/webview/.env.test; \
	fi
	@echo "create_webview_env done"

# rdbのディレクトリ作成
create_rdb_dir:
	@if [ ! -d ./app/rdb/postgresql/local ]; then \
		mkdir -p ./app/rdb/postgresql/local; \
	fi
	@if [ ! -d ./app/rdb/postgresql/test ]; then \
		mkdir -p ./app/rdb/postgresql/test; \
	fi

# 初期セットアップコマンド
init: create_root_env create_webview_env create_rdb_dir
	@echo "init done"

# Dockerコンテナ起動
docker-up:
	docker compose -f compose.${ENV}.yml up -d --build

# Dockerコンテナ削除
docker-down:
	docker compose -f compose.${ENV}.yml down --rmi all

# Dockerメモリ解放
docker-free:
	docker system prune