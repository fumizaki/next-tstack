import { z } from 'zod';
import * as validation from './validation';

export type NewAccount = z.infer<typeof validation.insertAccount>;