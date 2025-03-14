import { z } from 'zod';
import * as validation from './validation';

export type Account = z.infer<typeof validation.selectAccount>;