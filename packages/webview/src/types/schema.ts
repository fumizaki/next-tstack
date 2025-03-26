import type { z } from "zod";
import type * as validation from "./validation";

export type NewAccount = z.infer<typeof validation.insertAccount>;
