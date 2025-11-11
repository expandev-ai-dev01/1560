# TODO List - Sistema de Gerenciamento de Tarefas

## Estrutura do Projeto

Este projeto segue uma arquitetura modular baseada em domínios funcionais, com separação clara de responsabilidades.

### Estrutura de Diretórios

```
src/
├── app/                    # Configuração da aplicação
│   ├── App.tsx            # Componente raiz
│   ├── providers.tsx      # Provedores globais
│   └── router.tsx         # Configuração de rotas
├── assets/                # Recursos estáticos
│   └── styles/           # Estilos globais
├── core/                  # Componentes e lógica compartilhada
│   ├── components/       # Componentes genéricos
│   └── lib/              # Bibliotecas e configurações
├── domain/               # Domínios funcionais
└── pages/                # Páginas da aplicação
    └── layouts/          # Layouts compartilhados
```

## Tecnologias

- **React 18.3.1** - Biblioteca UI
- **TypeScript 5.6.3** - Tipagem estática
- **Vite 5.4.11** - Build tool
- **React Router 6.26.2** - Roteamento
- **TanStack Query 5.59.20** - Gerenciamento de estado do servidor
- **Tailwind CSS 3.4.14** - Framework CSS
- **Axios 1.7.7** - Cliente HTTP
- **Zustand 5.0.1** - Gerenciamento de estado
- **React Hook Form 7.53.1** - Gerenciamento de formulários
- **Zod 3.23.8** - Validação de schemas

## Scripts Disponíveis

```bash
# Desenvolvimento
npm run dev

# Build de produção
npm run build

# Preview do build
npm run preview

# Linting
npm run lint
```

## Configuração

1. Copie `.env.example` para `.env`
2. Configure as variáveis de ambiente:
   - `VITE_API_URL`: URL da API backend
   - `VITE_API_VERSION`: Versão da API (v1)
   - `VITE_API_TIMEOUT`: Timeout das requisições

## Estrutura de API

O frontend está configurado para consumir uma API REST com a seguinte estrutura:

- `/api/v1/external/*` - Endpoints públicos (login, registro)
- `/api/v1/internal/*` - Endpoints autenticados (tarefas, perfil)

## Padrões de Código

- **Componentes**: PascalCase (ex: `TaskCard`)
- **Hooks**: camelCase com prefixo `use` (ex: `useTaskList`)
- **Arquivos**: Estrutura modular com `main.tsx`, `types.ts`, `index.ts`
- **Estilos**: Tailwind CSS com classes utilitárias

## Próximos Passos

A estrutura base está pronta para receber as implementações das features:

1. Criação de Tarefas
2. Categorização de Tarefas
3. Definição de Prioridades
4. Estabelecimento de Prazos
5. Marcação de Conclusão
6. Busca de Tarefas
7. Notificações e Lembretes
8. Compartilhamento de Tarefas
9. Visualização em Calendário
10. Sincronização Multiplataforma