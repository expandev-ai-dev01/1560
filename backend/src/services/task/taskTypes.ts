/**
 * @interface TaskCreateParams
 * @description Parameters for creating a new task
 *
 * @property {number} idAccount - Account identifier
 * @property {number} idUser - User identifier
 * @property {string} title - Task title
 * @property {string} description - Task description
 * @property {string | null} dueDate - Due date
 * @property {string | null} dueTime - Due time
 * @property {number} priority - Priority level (0=low, 1=medium, 2=high)
 * @property {number | null} idCategory - Category identifier
 * @property {number | null} estimatedTime - Estimated time in minutes
 */
export interface TaskCreateParams {
  idAccount: number;
  idUser: number;
  title: string;
  description: string;
  dueDate: string | null;
  dueTime: string | null;
  priority: number;
  idCategory: number | null;
  estimatedTime: number | null;
}

/**
 * @interface TaskListParams
 * @description Parameters for listing tasks
 *
 * @property {number} idAccount - Account identifier
 * @property {number} idUser - User identifier
 * @property {number | null} status - Filter by status
 * @property {number | null} priority - Filter by priority
 * @property {string | null} dueDateFrom - Filter by due date from
 * @property {string | null} dueDateTo - Filter by due date to
 */
export interface TaskListParams {
  idAccount: number;
  idUser: number;
  status: number | null;
  priority: number | null;
  dueDateFrom: string | null;
  dueDateTo: string | null;
}

/**
 * @interface TaskGetParams
 * @description Parameters for getting a specific task
 *
 * @property {number} idAccount - Account identifier
 * @property {number} idUser - User identifier
 * @property {number} idTask - Task identifier
 */
export interface TaskGetParams {
  idAccount: number;
  idUser: number;
  idTask: number;
}

/**
 * @interface TaskUpdateParams
 * @description Parameters for updating a task
 *
 * @property {number} idAccount - Account identifier
 * @property {number} idUser - User identifier
 * @property {number} idTask - Task identifier
 * @property {string} title - Task title
 * @property {string} description - Task description
 * @property {string | null} dueDate - Due date
 * @property {string | null} dueTime - Due time
 * @property {number} priority - Priority level
 * @property {number} status - Task status
 * @property {number | null} idCategory - Category identifier
 * @property {number | null} estimatedTime - Estimated time in minutes
 */
export interface TaskUpdateParams {
  idAccount: number;
  idUser: number;
  idTask: number;
  title: string;
  description: string;
  dueDate: string | null;
  dueTime: string | null;
  priority: number;
  status: number;
  idCategory: number | null;
  estimatedTime: number | null;
}

/**
 * @interface TaskDeleteParams
 * @description Parameters for deleting a task
 *
 * @property {number} idAccount - Account identifier
 * @property {number} idUser - User identifier
 * @property {number} idTask - Task identifier
 */
export interface TaskDeleteParams {
  idAccount: number;
  idUser: number;
  idTask: number;
}

/**
 * @interface TaskCreateResult
 * @description Result of task creation
 *
 * @property {number} idTask - Created task identifier
 */
export interface TaskCreateResult {
  idTask: number;
}

/**
 * @interface TaskListResult
 * @description Task list item
 *
 * @property {number} idTask - Task identifier
 * @property {string} title - Task title
 * @property {string} description - Task description
 * @property {string | null} dueDate - Due date
 * @property {string | null} dueTime - Due time
 * @property {number} priority - Priority level
 * @property {number} status - Task status
 * @property {number | null} idCategory - Category identifier
 * @property {number | null} estimatedTime - Estimated time in minutes
 * @property {number} subtaskCount - Number of subtasks
 * @property {number} completedSubtaskCount - Number of completed subtasks
 * @property {number} attachmentCount - Number of attachments
 * @property {Date} dateCreated - Creation date
 * @property {Date} dateModified - Last modification date
 */
export interface TaskListResult {
  idTask: number;
  title: string;
  description: string;
  dueDate: string | null;
  dueTime: string | null;
  priority: number;
  status: number;
  idCategory: number | null;
  estimatedTime: number | null;
  subtaskCount: number;
  completedSubtaskCount: number;
  attachmentCount: number;
  dateCreated: Date;
  dateModified: Date;
}

/**
 * @interface TaskDetails
 * @description Detailed task information
 *
 * @property {number} idTask - Task identifier
 * @property {string} title - Task title
 * @property {string} description - Task description
 * @property {string | null} dueDate - Due date
 * @property {string | null} dueTime - Due time
 * @property {number} priority - Priority level
 * @property {number} status - Task status
 * @property {number | null} idCategory - Category identifier
 * @property {number | null} estimatedTime - Estimated time in minutes
 * @property {Date} dateCreated - Creation date
 * @property {Date} dateModified - Last modification date
 */
export interface TaskDetails {
  idTask: number;
  title: string;
  description: string;
  dueDate: string | null;
  dueTime: string | null;
  priority: number;
  status: number;
  idCategory: number | null;
  estimatedTime: number | null;
  dateCreated: Date;
  dateModified: Date;
}

/**
 * @interface Subtask
 * @description Subtask information
 *
 * @property {number} idSubtask - Subtask identifier
 * @property {string} title - Subtask title
 * @property {boolean} completed - Completion status
 * @property {Date} dateCreated - Creation date
 */
export interface Subtask {
  idSubtask: number;
  title: string;
  completed: boolean;
  dateCreated: Date;
}

/**
 * @interface Tag
 * @description Task tag
 *
 * @property {string} tag - Tag name
 */
export interface Tag {
  tag: string;
}

/**
 * @interface Attachment
 * @description Task attachment
 *
 * @property {number} idAttachment - Attachment identifier
 * @property {string} fileName - File name
 * @property {string} fileType - File type
 * @property {number} fileSize - File size in bytes
 * @property {Date} dateCreated - Upload date
 */
export interface Attachment {
  idAttachment: number;
  fileName: string;
  fileType: string;
  fileSize: number;
  dateCreated: Date;
}

/**
 * @interface TaskGetResult
 * @description Result of task get operation
 *
 * @property {TaskDetails} task - Task details
 * @property {Subtask[]} subtasks - List of subtasks
 * @property {Tag[]} tags - List of tags
 * @property {Attachment[]} attachments - List of attachments
 */
export interface TaskGetResult {
  task: TaskDetails;
  subtasks: Subtask[];
  tags: Tag[];
  attachments: Attachment[];
}

/**
 * @interface TaskUpdateResult
 * @description Result of task update operation
 *
 * @property {number} success - Update success indicator
 */
export interface TaskUpdateResult {
  success: number;
}

/**
 * @interface TaskDeleteResult
 * @description Result of task delete operation
 *
 * @property {number} success - Deletion success indicator
 */
export interface TaskDeleteResult {
  success: number;
}
