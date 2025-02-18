import { relations } from 'drizzle-orm';
import { pgTable, timestamp, uuid, varchar, char, text, integer, bigint } from 'drizzle-orm/pg-core';

const timestampMixin = {
    createdAt: timestamp('created_at').notNull().defaultNow(),
    updatedAt: timestamp('updated_at').notNull().defaultNow().$onUpdate(() => new Date()),
    deletedAt: timestamp('deleted_at'),
};

const table = {
    id: uuid('id').defaultRandom().notNull().primaryKey(),
    ...timestampMixin,
}

export const AccountTable = pgTable('account', {
    ...table,
    email: text('email').notNull()
});