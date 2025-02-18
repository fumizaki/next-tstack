import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from '@/rdb/postgresql/table';

export const client = postgres(`postgresql://${process.env.RDB_USER}:${process.env.RDB_PASSWORD}@${process.env.RDB_HOST}:${process.env.RDB_PORT}/${process.env.RDB_NAME}`);
export const session = drizzle(client, { schema });