import { defineConfig } from 'drizzle-kit';
import { loadEnvConfig } from '@next/env';

loadEnvConfig(process.cwd());

export default defineConfig({
    dialect: 'postgresql',
    schema: './src/rdb/postgresql/table.ts',
    out: './src/rdb/postgresql/migrations',
    dbCredentials: {
        url: `${process.env.PSQL_URL}`,
    },
});