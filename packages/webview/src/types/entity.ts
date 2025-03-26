import type { z } from "zod";
import type * as validation from "./validation";

export type Account = z.infer<typeof validation.selectAccount>;
