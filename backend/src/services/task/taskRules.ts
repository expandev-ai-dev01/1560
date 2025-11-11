import { dbRequest, ExpectedReturn } from '@/utils/database';
import {
  TaskCreateParams,
  TaskListParams,
  TaskGetParams,
  TaskUpdateParams,
  TaskDeleteParams,
  TaskCreateResult,
  TaskListResult,
  TaskGetResult,
  TaskUpdateResult,
  TaskDeleteResult,
} from './taskTypes';

/**
 * @summary
 * Creates a new task with basic information
 *
 * @function taskCreate
 * @module task
 *
 * @param {TaskCreateParams} params - Task creation parameters
 * @param {number} params.idAccount - Account identifier
 * @param {number} params.idUser - User identifier
 * @param {string} params.title - Task title
 * @param {string} params.description - Task description
 * @param {string | null} params.dueDate - Due date
 * @param {string | null} params.dueTime - Due time
 * @param {number} params.priority - Priority level
 * @param {number | null} params.idCategory - Category identifier
 * @param {number | null} params.estimatedTime - Estimated time in minutes
 *
 * @returns {Promise<TaskCreateResult>} Created task identifier
 *
 * @throws {ValidationError} When parameters fail validation
 * @throws {BusinessRuleError} When business rules are violated
 * @throws {DatabaseError} When database operation fails
 */
export async function taskCreate(params: TaskCreateParams): Promise<TaskCreateResult> {
  const result = await dbRequest(
    '[functional].[spTaskCreate]',
    {
      idAccount: params.idAccount,
      idUser: params.idUser,
      title: params.title,
      description: params.description,
      dueDate: params.dueDate,
      dueTime: params.dueTime,
      priority: params.priority,
      idCategory: params.idCategory,
      estimatedTime: params.estimatedTime,
    },
    ExpectedReturn.Single
  );

  return result;
}

/**
 * @summary
 * Lists all tasks for a specific user with optional filters
 *
 * @function taskList
 * @module task
 *
 * @param {TaskListParams} params - Task list parameters
 * @param {number} params.idAccount - Account identifier
 * @param {number} params.idUser - User identifier
 * @param {number | null} params.status - Filter by status
 * @param {number | null} params.priority - Filter by priority
 * @param {string | null} params.dueDateFrom - Filter by due date from
 * @param {string | null} params.dueDateTo - Filter by due date to
 *
 * @returns {Promise<TaskListResult[]>} List of tasks
 *
 * @throws {ValidationError} When parameters fail validation
 * @throws {DatabaseError} When database operation fails
 */
export async function taskList(params: TaskListParams): Promise<TaskListResult[]> {
  const result = await dbRequest(
    '[functional].[spTaskList]',
    {
      idAccount: params.idAccount,
      idUser: params.idUser,
      status: params.status,
      priority: params.priority,
      dueDateFrom: params.dueDateFrom,
      dueDateTo: params.dueDateTo,
    },
    ExpectedReturn.Multi
  );

  return result;
}

/**
 * @summary
 * Retrieves detailed information about a specific task
 *
 * @function taskGet
 * @module task
 *
 * @param {TaskGetParams} params - Task get parameters
 * @param {number} params.idAccount - Account identifier
 * @param {number} params.idUser - User identifier
 * @param {number} params.idTask - Task identifier
 *
 * @returns {Promise<TaskGetResult>} Task details with related data
 *
 * @throws {ValidationError} When parameters fail validation
 * @throws {BusinessRuleError} When task doesn't exist or access denied
 * @throws {DatabaseError} When database operation fails
 */
export async function taskGet(params: TaskGetParams): Promise<TaskGetResult> {
  const result = await dbRequest(
    '[functional].[spTaskGet]',
    {
      idAccount: params.idAccount,
      idUser: params.idUser,
      idTask: params.idTask,
    },
    ExpectedReturn.Multi,
    undefined,
    ['task', 'subtasks', 'tags', 'attachments']
  );

  return {
    task: result.task[0],
    subtasks: result.subtasks,
    tags: result.tags,
    attachments: result.attachments,
  };
}

/**
 * @summary
 * Updates an existing task with new information
 *
 * @function taskUpdate
 * @module task
 *
 * @param {TaskUpdateParams} params - Task update parameters
 * @param {number} params.idAccount - Account identifier
 * @param {number} params.idUser - User identifier
 * @param {number} params.idTask - Task identifier
 * @param {string} params.title - Task title
 * @param {string} params.description - Task description
 * @param {string | null} params.dueDate - Due date
 * @param {string | null} params.dueTime - Due time
 * @param {number} params.priority - Priority level
 * @param {number} params.status - Task status
 * @param {number | null} params.idCategory - Category identifier
 * @param {number | null} params.estimatedTime - Estimated time in minutes
 *
 * @returns {Promise<TaskUpdateResult>} Update success indicator
 *
 * @throws {ValidationError} When parameters fail validation
 * @throws {BusinessRuleError} When task doesn't exist or access denied
 * @throws {DatabaseError} When database operation fails
 */
export async function taskUpdate(params: TaskUpdateParams): Promise<TaskUpdateResult> {
  const result = await dbRequest(
    '[functional].[spTaskUpdate]',
    {
      idAccount: params.idAccount,
      idUser: params.idUser,
      idTask: params.idTask,
      title: params.title,
      description: params.description,
      dueDate: params.dueDate,
      dueTime: params.dueTime,
      priority: params.priority,
      status: params.status,
      idCategory: params.idCategory,
      estimatedTime: params.estimatedTime,
    },
    ExpectedReturn.Single
  );

  return result;
}

/**
 * @summary
 * Soft deletes a task and all related data
 *
 * @function taskDelete
 * @module task
 *
 * @param {TaskDeleteParams} params - Task delete parameters
 * @param {number} params.idAccount - Account identifier
 * @param {number} params.idUser - User identifier
 * @param {number} params.idTask - Task identifier
 *
 * @returns {Promise<TaskDeleteResult>} Deletion success indicator
 *
 * @throws {ValidationError} When parameters fail validation
 * @throws {BusinessRuleError} When task doesn't exist or access denied
 * @throws {DatabaseError} When database operation fails
 */
export async function taskDelete(params: TaskDeleteParams): Promise<TaskDeleteResult> {
  const result = await dbRequest(
    '[functional].[spTaskDelete]',
    {
      idAccount: params.idAccount,
      idUser: params.idUser,
      idTask: params.idTask,
    },
    ExpectedReturn.Single
  );

  return result;
}
