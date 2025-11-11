export interface Task {
  id: number;
  title: string;
  description: string;
  dueDate: string | null;
  dueTime: string | null;
  priority: number;
  status: number;
  idCategory: number | null;
  estimatedTime: number | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreateTaskDto {
  title: string;
  description?: string;
  dueDate?: string;
  dueTime?: string;
  priority?: number;
  idCategory?: number;
  estimatedTime?: number;
}

export interface UpdateTaskDto {
  title: string;
  description?: string;
  dueDate?: string;
  dueTime?: string;
  priority: number;
  status: number;
  idCategory?: number;
  estimatedTime?: number;
}

export interface TaskListParams {
  status?: number;
  priority?: number;
  dueDateFrom?: string;
  dueDateTo?: string;
}

export const TASK_PRIORITY = {
  LOW: 0,
  MEDIUM: 1,
  HIGH: 2,
} as const;

export const TASK_STATUS = {
  PENDING: 0,
  IN_PROGRESS: 1,
  COMPLETED: 2,
  CANCELLED: 3,
} as const;

export const PRIORITY_LABELS: Record<number, string> = {
  [TASK_PRIORITY.LOW]: 'Baixa',
  [TASK_PRIORITY.MEDIUM]: 'Média',
  [TASK_PRIORITY.HIGH]: 'Alta',
};

export const STATUS_LABELS: Record<number, string> = {
  [TASK_STATUS.PENDING]: 'Pendente',
  [TASK_STATUS.IN_PROGRESS]: 'Em Andamento',
  [TASK_STATUS.COMPLETED]: 'Concluída',
  [TASK_STATUS.CANCELLED]: 'Cancelada',
};
