import { defineConfig } from 'drizzle-kit';
import { loadEnvConfig } from '@next/env';

loadEnvConfig(process.cwd());

export default defineConfig({
    dialect: 'postgresql',
    schema: './src/rdb/postgresql/table.ts',
    out: './migrations',
    dbCredentials: {
        url: `postgresql://${process.env.RDB_USER}:${process.env.RDB_PASSWORD}@${process.env.RDB_HOST}:${process.env.RDB_PORT}/${process.env.RDB_NAME}`,
    },
});