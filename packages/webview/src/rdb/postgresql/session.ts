import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "@/rdb/postgresql/table";

export const client = postgres(`${process.env.PSQL_URL}`);
export const session = drizzle(client, { schema });
