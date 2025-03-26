import { z } from "zod";

const selectBaseValidation = z.object({
	id: z.string().uuid(),
	createdAt: z.coerce.date(),
	updatedAt: z.coerce.date(),
	deletedAt: z.coerce.date().nullable(),
});

export const selectAccount = selectBaseValidation.extend({
	email: z.string().email(),
});

export const insertAccount = z.object({
	email: z.string().email(),
	password: z.string().trim().min(8),
});
