import { useNavigate } from 'react-router-dom';
import { TaskForm } from '@/domain/task/components/TaskForm';
import { useTaskCreate } from '@/domain/task/hooks/useTaskCreate';
import type { CreateTaskDto } from '@/domain/task/types';

export const TaskCreatePage = () => {
  const navigate = useNavigate();
  const { createTask, isCreating } = useTaskCreate({
    onSuccess: () => {
      navigate('/');
    },
    onError: (error: Error) => {
      alert(`Erro ao criar tarefa: ${error.message}`);
    },
  });

  const handleSubmit = async (data: CreateTaskDto) => {
    try {
      await createTask(data);
    } catch (error: unknown) {
      console.error('Erro ao criar tarefa:', error);
    }
  };

  const handleCancel = () => {
    navigate('/');
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-3xl mx-auto px-4">
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="mb-6">
            <h1 className="text-2xl font-bold text-gray-900">Criar Nova Tarefa</h1>
            <p className="mt-1 text-sm text-gray-600">
              Preencha os campos abaixo para criar uma nova tarefa
            </p>
          </div>

          <TaskForm onSubmit={handleSubmit} onCancel={handleCancel} isSubmitting={isCreating} />
        </div>
      </div>
    </div>
  );
};

export default TaskCreatePage;
