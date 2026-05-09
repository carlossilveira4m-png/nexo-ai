# Estrutura do Projeto Nexo AI

## Organização de Diretórios

```
nexo-ai/
├── frontend/                          # Aplicativo Flutter
│   ├── lib/
│   │   ├── main.dart                 # Ponto de entrada
│   │   ├── config/                   # Configurações globais
│   │   │   ├── app_config.dart
│   │   │   ├── routes.dart
│   │   │   └── theme.dart
│   │   ├── core/                     # Código compartilhado
│   │   │   ├── constants/
│   │   │   ├── extensions/
│   │   │   ├── utils/
│   │   │   ├── network/              # HTTP Client
│   │   │   ├── storage/              # Local Storage
│   │   │   └── services/             # Serviços globais
│   │   ├── features/                 # Features por página
│   │   │   ├── auth/
│   │   │   │   ├── presentation/
│   │   │   │   ├── data/
│   │   │   │   └── domain/
│   │   │   ├── chat/
│   │   │   ├── memory/
│   │   │   ├── tasks/
│   │   │   ├── calendar/
│   │   │   ├── profile/
│   │   │   ├── payments/
│   │   │   └── dashboard/
│   │   └── widgets/                  # Widgets reutilizáveis
│   │       ├── common/
│   │       └── premium/
│   ├── pubspec.yaml                  # Dependências
│   ├── analysis_options.yaml          # Lint rules
│   └── .env.example
│
├── backend/                           # API Node.js
│   ├── src/
│   │   ├── main.ts                   # Entry point
│   │   ├── config/                   # Configurações
│   │   │   ├── database.ts
│   │   │   ├── stripe.ts
│   │   │   ├── openai.ts
│   │   │   └── supabase.ts
│   │   ├── middleware/               # Middlewares
│   │   │   ├── auth.ts
│   │   │   ├── errorHandler.ts
│   │   │   └── cors.ts
│   │   ├── routes/                   # Rotas API
│   │   │   ├── auth.ts
│   │   │   ├── chat.ts
│   │   │   ├── memory.ts
│   │   │   ├── tasks.ts
│   │   │   ├── payments.ts
│   │   │   └── user.ts
│   │   ├── controllers/              # Lógica de requisições
│   │   ├── services/                 # Serviços de negócio
│   │   │   ├── AuthService.ts
│   │   │   ├── ChatService.ts
│   │   │   ├── PaymentService.ts
│   │   │   ├── MemoryService.ts
│   │   │   └── StripeService.ts
│   │   ├── models/                   # Modelos de dados
│   │   ├── utils/                    # Utilitários
│   │   ├── types/                    # TypeScript types
│   │   └── jobs/                     # Background jobs
│   ├── migrations/                   # Database migrations
│   ├── seeds/                        # Database seeds
│   ├── tests/
│   ├── package.json
│   ├── tsconfig.json
│   ├── .env.example
│   └── Dockerfile
│
├── database/                          # Scripts PostgreSQL
│   ├── init.sql                      # Schema inicial
│   ├── migrations/
│   │   ├── 001_create_users.sql
│   │   ├── 002_create_chats.sql
│   │   ├── 003_create_memories.sql
│   │   ├── 004_create_tasks.sql
│   │   ├── 005_create_payments.sql
│   │   └── 006_create_embeddings.sql
│   └── seed.sql
│
├── docs/
│   ├── API.md                        # Documentação API
│   ├── DATABASE.md                   # Schema e queries
│   ├── DESIGN.md                     # Design system
│   ├── PAYMENTS.md                   # Sistema de pagamentos
│   ├── ARCHITECTURE.md               # Arquitetura geral
│   ├── INSTALLATION.md               # Guia de instalação
│   ├── DEPLOYMENT.md                 # Deploy
│   └── PROJECT_STRUCTURE.md          # Este arquivo
│
├── .github/
│   └── workflows/
│       ├── flutter-build.yml
│       ├── backend-test.yml
│       └── deploy.yml
│
├── docker-compose.yml                # Setup local
├── .env.example                      # Vars de env
└── package.json                      # Scripts gerais
```

## Clean Architecture

O projeto segue **Clean Architecture** em Flutter e padrão **MVC** no backend.

### Frontend (Flutter)
- **Presentation Layer**: UI, widgets, pages
- **Domain Layer**: Entities, repositories (abstratos), use cases
- **Data Layer**: Datasources, repositories (concreto), models

### Backend (Node.js)
- **Routes**: Define endpoints
- **Controllers**: Recebem requisições
- **Services**: Lógica de negócio
- **Models**: Estrutura de dados
- **Database**: Acesso a dados

## Padrões de Design

### Frontend
- **Riverpod**: State management
- **Freezed**: Value objects
- **GoRouter**: Navigation
- **Service Locator**: Injeção de dependência

### Backend
- **Express**: Web framework
- **Middleware**: Autenticação, validação
- **Service Pattern**: Separação de responsabilidades
- **JWT**: Autenticação stateless

## Convenções de Código

### Nomenclatura
- Classes: `PascalCase`
- Funções/variáveis: `camelCase`
- Constantes: `UPPER_SNAKE_CASE`
- Diretórios: `lowercase_with_underscores`

### Commits
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação
- `refactor:` Refatoração
- `test:` Testes
- `chore:` Configuração
