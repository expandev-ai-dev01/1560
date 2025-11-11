import { useNavigate } from 'react-router-dom';

export const HomePage = () => {
  const navigate = useNavigate();

  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">TODO List</h1>
        <p className="text-lg text-gray-600 mb-8">Sistema de Gerenciamento de Tarefas</p>
        <div className="space-y-4">
          <button
            onClick={() => navigate('/tasks/create')}
            className="bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors font-medium"
          >
            Criar Nova Tarefa
          </button>
          <div className="space-y-2 text-sm text-gray-500">
            <p>Frontend estrutura base criada com sucesso!</p>
            <p>Feature de Criação de Tarefas implementada.</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
