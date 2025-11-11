import { Request } from 'express';
import { z } from 'zod';

export interface CrudPermission {
  securable: string;
  permission: 'CREATE' | 'READ' | 'UPDATE' | 'DELETE';
}

export interface ValidationResult {
  credential: {
    idAccount: number;
    idUser: number;
  };
  params?: any;
  body?: any;
}

export class CrudController {
  private permissions: CrudPermission[];

  constructor(permissions: CrudPermission[]) {
    this.permissions = permissions;
  }

  async create(req: Request, bodySchema: z.ZodSchema): Promise<[ValidationResult | null, any]> {
    try {
      const body = await bodySchema.parseAsync(req.body);

      const validated: ValidationResult = {
        credential: {
          idAccount: 1,
          idUser: 1,
        },
        body,
      };

      return [validated, null];
    } catch (error) {
      return [null, error];
    }
  }

  async read(req: Request, paramsSchema?: z.ZodSchema): Promise<[ValidationResult | null, any]> {
    try {
      const params = paramsSchema ? await paramsSchema.parseAsync(req.params) : {};

      const validated: ValidationResult = {
        credential: {
          idAccount: 1,
          idUser: 1,
        },
        params,
      };

      return [validated, null];
    } catch (error) {
      return [null, error];
    }
  }

  async update(
    req: Request,
    paramsSchema: z.ZodSchema,
    bodySchema: z.ZodSchema
  ): Promise<[ValidationResult | null, any]> {
    try {
      const params = await paramsSchema.parseAsync(req.params);
      const body = await bodySchema.parseAsync(req.body);

      const validated: ValidationResult = {
        credential: {
          idAccount: 1,
          idUser: 1,
        },
        params,
        body,
      };

      return [validated, null];
    } catch (error) {
      return [null, error];
    }
  }

  async delete(req: Request, paramsSchema: z.ZodSchema): Promise<[ValidationResult | null, any]> {
    try {
      const params = await paramsSchema.parseAsync(req.params);

      const validated: ValidationResult = {
        credential: {
          idAccount: 1,
          idUser: 1,
        },
        params,
      };

      return [validated, null];
    } catch (error) {
      return [null, error];
    }
  }
}

export const successResponse = (data: any) => ({
  success: true,
  data,
  timestamp: new Date().toISOString(),
});

export const errorResponse = (message: string, code?: string) => ({
  success: false,
  error: {
    code: code || 'ERROR',
    message,
  },
  timestamp: new Date().toISOString(),
});

export const StatusGeneralError = {
  statusCode: 500,
  code: 'INTERNAL_SERVER_ERROR',
  message: 'An unexpected error occurred',
};
