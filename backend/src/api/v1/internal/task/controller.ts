import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import {
  CrudController,
  errorResponse,
  StatusGeneralError,
  successResponse,
} from '@/middleware/crud';
import { taskCreate, taskList, taskGet, taskUpdate, taskDelete } from '@/services/task';

const securable = 'TASK';

const createBodySchema = z.object({
  title: z.string().min(3).max(100),
  description: z.string().max(1000).optional().nullable(),
  dueDate: z.string().optional().nullable(),
  dueTime: z.string().optional().nullable(),
  priority: z.number().int().min(0).max(2).optional().nullable(),
  idCategory: z.number().int().positive().optional().nullable(),
  estimatedTime: z.number().int().min(5).max(1440).optional().nullable(),
});

const listQuerySchema = z.object({
  status: z.coerce.number().int().min(0).max(3).optional(),
  priority: z.coerce.number().int().min(0).max(2).optional(),
  dueDateFrom: z.string().optional(),
  dueDateTo: z.string().optional(),
});

const getParamsSchema = z.object({
  id: z.coerce.number().int().positive(),
});

const updateParamsSchema = z.object({
  id: z.coerce.number().int().positive(),
});

const updateBodySchema = z.object({
  title: z.string().min(3).max(100),
  description: z.string().max(1000).optional().nullable(),
  dueDate: z.string().optional().nullable(),
  dueTime: z.string().optional().nullable(),
  priority: z.number().int().min(0).max(2),
  status: z.number().int().min(0).max(3),
  idCategory: z.number().int().positive().optional().nullable(),
  estimatedTime: z.number().int().min(5).max(1440).optional().nullable(),
});

const deleteParamsSchema = z.object({
  id: z.coerce.number().int().positive(),
});

export async function postHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  const operation = new CrudController([{ securable, permission: 'CREATE' }]);

  const [validated, error] = await operation.create(req, createBodySchema);

  if (!validated) {
    return next(error);
  }

  try {
    const data = await taskCreate({
      idAccount: validated.credential.idAccount,
      idUser: validated.credential.idUser,
      title: validated.body.title,
      description: validated.body.description || '',
      dueDate: validated.body.dueDate || null,
      dueTime: validated.body.dueTime || null,
      priority: validated.body.priority ?? 1,
      idCategory: validated.body.idCategory || null,
      estimatedTime: validated.body.estimatedTime || null,
    });

    res.json(successResponse(data));
  } catch (error: any) {
    if (error.number === 51000) {
      res.status(400).json(errorResponse(error.message));
    } else {
      next(StatusGeneralError);
    }
  }
}

export async function getHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  const operation = new CrudController([{ securable, permission: 'READ' }]);

  const [validated, error] = await operation.read(req, listQuerySchema);

  if (!validated) {
    return next(error);
  }

  try {
    const data = await taskList({
      idAccount: validated.credential.idAccount,
      idUser: validated.credential.idUser,
      status: validated.params?.status || null,
      priority: validated.params?.priority || null,
      dueDateFrom: validated.params?.dueDateFrom || null,
      dueDateTo: validated.params?.dueDateTo || null,
    });

    res.json(successResponse(data));
  } catch (error: any) {
    if (error.number === 51000) {
      res.status(400).json(errorResponse(error.message));
    } else {
      next(StatusGeneralError);
    }
  }
}

export async function getByIdHandler(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  const operation = new CrudController([{ securable, permission: 'READ' }]);

  const [validated, error] = await operation.read(req, getParamsSchema);

  if (!validated) {
    return next(error);
  }

  try {
    const data = await taskGet({
      idAccount: validated.credential.idAccount,
      idUser: validated.credential.idUser,
      idTask: validated.params.id,
    });

    res.json(successResponse(data));
  } catch (error: any) {
    if (error.number === 51000) {
      res.status(400).json(errorResponse(error.message));
    } else {
      next(StatusGeneralError);
    }
  }
}

export async function putHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  const operation = new CrudController([{ securable, permission: 'UPDATE' }]);

  const [validated, error] = await operation.update(req, updateParamsSchema, updateBodySchema);

  if (!validated) {
    return next(error);
  }

  try {
    const data = await taskUpdate({
      idAccount: validated.credential.idAccount,
      idUser: validated.credential.idUser,
      idTask: validated.params.id,
      title: validated.body.title,
      description: validated.body.description || '',
      dueDate: validated.body.dueDate || null,
      dueTime: validated.body.dueTime || null,
      priority: validated.body.priority,
      status: validated.body.status,
      idCategory: validated.body.idCategory || null,
      estimatedTime: validated.body.estimatedTime || null,
    });

    res.json(successResponse(data));
  } catch (error: any) {
    if (error.number === 51000) {
      res.status(400).json(errorResponse(error.message));
    } else {
      next(StatusGeneralError);
    }
  }
}

export async function deleteHandler(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  const operation = new CrudController([{ securable, permission: 'DELETE' }]);

  const [validated, error] = await operation.delete(req, deleteParamsSchema);

  if (!validated) {
    return next(error);
  }

  try {
    const data = await taskDelete({
      idAccount: validated.credential.idAccount,
      idUser: validated.credential.idUser,
      idTask: validated.params.id,
    });

    res.json(successResponse(data));
  } catch (error: any) {
    if (error.number === 51000) {
      res.status(400).json(errorResponse(error.message));
    } else {
      next(StatusGeneralError);
    }
  }
}
