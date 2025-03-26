import type { SQL } from "drizzle-orm";
import type { PgColumn, PgSelect } from "drizzle-orm/pg-core";

export function withPagination<T extends PgSelect>(
	query: T,
	orderByColumn: PgColumn | SQL | SQL.Aliased,
	page = 1,
	pageSize = 9,
) {
	return query
		.orderBy(orderByColumn)
		.limit(pageSize)
		.offset((page - 1) * pageSize);
}
