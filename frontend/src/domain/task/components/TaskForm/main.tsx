import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import type { TaskFormProps, TaskFormData } from './types';
import { TASK_PRIORITY } from '../../types';

const taskFormSchema = z.object({
  title: z
    .string()
    .min(3, 'O título deve ter pelo menos 3 caracteres')
    .max(100, 'O título deve ter no máximo 100 caracteres'),
  description: z.string().max(1000, 'A descrição deve ter no máximo 1000 caracteres').optional(),
  dueDate: z.string().optional(),
  dueTime: z.string().optional(),
  priority: z.coerce.number().int().min(0).max(2).optional(),
  idCategory: z.string().optional(),
  estimatedTime: z.string().optional(),
});

export const TaskForm = ({
  onSubmit,
  onCancel,
  isSubmitting = false,
  initialData,
}: TaskFormProps) => {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<TaskFormData>({
    resolver: zodResolver(taskFormSchema),
    defaultValues: {
      title: initialData?.title || '',
      description: initialData?.description || '',
      dueDate: initialData?.dueDate || '',
      dueTime: initialData?.dueTime || '',
      priority: initialData?.priority ?? TASK_PRIORITY.MEDIUM,
      idCategory: initialData?.idCategory?.toString() || '',
      estimatedTime: initialData?.estimatedTime?.toString() || '',
    },
  });

  const handleFormSubmit = (data: TaskFormData) => {
    const submitData = {
      title: data.title,
      description: data.description || undefined,
      dueDate: data.dueDate || undefined,
      dueTime: data.dueTime || undefined,
      priority: data.priority !== undefined ? Number(data.priority) : undefined,
      idCategory: data.idCategory ? Number(data.idCategory) : undefined,
      estimatedTime: data.estimatedTime ? Number(data.estimatedTime) : undefined,
    };
    onSubmit(submitData);
  };

  return (
    <form onSubmit={handleSubmit(handleFormSubmit)} className="space-y-6">
      <div>
        <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-1">
          Título <span className="text-red-500">*</span>
        </label>
        <input
          {...register('title')}
          type="text"
          id="title"
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Digite o título da tarefa"
          disabled={isSubmitting}
        />
        {errors.title && <p className="mt-1 text-sm text-red-600">{errors.title.message}</p>}
      </div>

      <div>
        <label htmlFor="description" className="block text-sm font-medium text-gray-700 mb-1">
          Descrição
        </label>
        <textarea
          {...register('description')}
          id="description"
          rows={4}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Descreva os detalhes da tarefa"
          disabled={isSubmitting}
        />
        {errors.description && (
          <p className="mt-1 text-sm text-red-600">{errors.description.message}</p>
        )}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label htmlFor="dueDate" className="block text-sm font-medium text-gray-700 mb-1">
            Data de Vencimento
          </label>
          <input
            {...register('dueDate')}
            type="date"
            id="dueDate"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={isSubmitting}
          />
          {errors.dueDate && <p className="mt-1 text-sm text-red-600">{errors.dueDate.message}</p>}
        </div>

        <div>
          <label htmlFor="dueTime" className="block text-sm font-medium text-gray-700 mb-1">
            Hora de Vencimento
          </label>
          <input
            {...register('dueTime')}
            type="time"
            id="dueTime"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={isSubmitting}
          />
          {errors.dueTime && <p className="mt-1 text-sm text-red-600">{errors.dueTime.message}</p>}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label htmlFor="priority" className="block text-sm font-medium text-gray-700 mb-1">
            Prioridade
          </label>
          <select
            {...register('priority')}
            id="priority"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={isSubmitting}
          >
            <option value={TASK_PRIORITY.LOW}>Baixa</option>
            <option value={TASK_PRIORITY.MEDIUM}>Média</option>
            <option value={TASK_PRIORITY.HIGH}>Alta</option>
          </select>
          {errors.priority && (
            <p className="mt-1 text-sm text-red-600">{errors.priority.message}</p>
          )}
        </div>

        <div>
          <label htmlFor="estimatedTime" className="block text-sm font-medium text-gray-700 mb-1">
            Tempo Estimado (minutos)
          </label>
          <input
            {...register('estimatedTime')}
            type="number"
            id="estimatedTime"
            min="5"
            max="1440"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Ex: 60"
            disabled={isSubmitting}
          />
          {errors.estimatedTime && (
            <p className="mt-1 text-sm text-red-600">{errors.estimatedTime.message}</p>
          )}
        </div>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          disabled={isSubmitting}
          className="flex-1 bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {isSubmitting ? 'Criando...' : 'Criar Tarefa'}
        </button>
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            disabled={isSubmitting}
            className="flex-1 bg-gray-200 text-gray-900 px-4 py-2 rounded-md hover:bg-gray-300 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Cancelar
          </button>
        )}
      </div>
    </form>
  );
};
