# Arquitetura do Nexo AI

## Visão Geral

Nexo AI é uma aplicação **mobile-first** baseada em arquitetura em camadas, seguindo princípios de **Clean Architecture** no frontend e padrão **MVC** no backend.

```
┌─────────────────────────────────────────────────────────────────┐
│                   Mobile App (Flutter)                           │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Presentation Layer (UI, State Management)                  ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Domain Layer (Entities, Use Cases, Repos)                  ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Data Layer (Models, Data Sources, Repos Impl)              ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
└─────────────────────────────────────────────────────────────────┘
                          ↕ HTTP/WebSocket
                    (API REST + Realtime)
┌─────────────────────────────────────────────────────────────────┐
│              Backend API (Node.js/Express)                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Routes (API Endpoints)                                     ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Middleware (Auth, Validation, Error Handling)              ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Controllers (Request Handling)                             ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Services (Business Logic)                                  ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Models & Database (Data Persistence)                       ││
│  └─────────────────────────────────────────────────────────────┘│
│                          ↕                                       │
└─────────────────────────────────────────────────────────────────┘
                          ↕
          ┌──────────────┼──────────────┐
          ↓              ↓              ↓
    PostgreSQL      OpenAI API      Vector DB
    (Primary DB)   (AI/LLM)        (Memory)
```

## Componentes Principais

### 1. Frontend (Flutter)

#### Presentation Layer
- **Pages**: Telas principais do app
  - `SplashPage` - Tela de splash
  - `OnboardingPage` - Onboarding inicial
  - `LoginPage` - Autenticação
  - `DashboardPage` - Home principal
  - `ChatPage` - Chat com IA
  - `MemoryPage` - Armazenamento de memória
  - `TasksPage` - Gerenciamento de tarefas
  - `CalendarPage` - Calendário
  - `ProfilePage` - Perfil do usuário
  - `PremiumPage` - Upgrade de plano
  - `PaymentsPage` - Gerenciamento de pagamentos

- **Widgets**: Componentes reutilizáveis
  - `ChatBubble` - Mensagem de chat
  - `MemoryCard` - Card de memória
  - `TaskItem` - Item de tarefa
  - `PremiumButton` - Botão de upgrade
  - `LoadingOverlay` - Overlay de loading

#### Domain Layer
- **Entities**: Objetos de domínio imutáveis
  - `User`
  - `ChatMessage`
  - `Memory`
  - `Task`
  - `Subscription`

- **Repositories**: Interfaces de acesso a dados
  - `AuthRepository`
  - `ChatRepository`
  - `MemoryRepository`
  - `TaskRepository`
  - `PaymentRepository`

#### Data Layer
- **Models**: DTOs com serialização
- **Remote Data Source**: API integration
- **Local Data Source**: SQLite/Hive

### 2. Backend (Node.js)

#### Routes
```
GET/POST  /api/auth/*          - Autenticação
GET/POST  /api/chat/*          - Chat com IA
GET/POST  /api/memory/*        - Memória
GET/POST  /api/tasks/*         - Tarefas
GET/POST  /api/payments/*      - Pagamentos
GET/PUT   /api/user/*          - Dados do usuário
```

#### Services
- **AuthService**: Cadastro, login, refresh token
- **ChatService**: Integração OpenAI, salva histórico
- **MemoryService**: CRUD memory, busca inteligente
- **TaskService**: CRUD tarefas, automação
- **PaymentService**: Integração Stripe
- **StripeService**: Webhooks, subscrições

### 3. Banco de Dados

#### PostgreSQL Tables

**users**
```sql
id UUID PK
email VARCHAR UNIQUE
password_hash VARCHAR
full_name VARCHAR
avatar_url VARCHAR
plan TEXT (free|premium|pro)
status TEXT (active|inactive|deleted)
created_at TIMESTAMP
```

**chat_messages**
```sql
id UUID PK
user_id UUID FK
role TEXT (user|assistant)
content TEXT
embedding VECTOR (1536)
created_at TIMESTAMP
```

**memories**
```sql
id UUID PK
user_id UUID FK
type TEXT (link|text|idea|note|task)
content TEXT
tags TEXT[]
embedding VECTOR (1536)
created_at TIMESTAMP
```

**subscriptions**
```sql
id UUID PK
user_id UUID FK
plan TEXT
stripe_subscription_id VARCHAR
status TEXT (active|cancelled)
start_date TIMESTAMP
end_date TIMESTAMP
```

**payments**
```sql
id UUID PK
user_id UUID FK
stripe_payment_id VARCHAR
amount INT
status TEXT
method TEXT (stripe|google_play|apple|pix)
created_at TIMESTAMP
```

## Fluxos de Dados

### Fluxo de Chat

```
Usuário digita mensagem
  ↓
ChatPage captura input
  ↓
ChatProvider.sendMessage()
  ↓
SendChatMessageUseCase
  ↓
ChatRepository.sendMessage()
  ↓
RemoteDataSource.postMessage()
  ↓
HTTP POST /api/chat/send
  ↓
ChatController.sendMessage()
  ↓
ChatService.processMessage()
  - Salva no DB
  - Cria embedding
  - Chama OpenAI
  - Retorna resposta
  ↓
Response 200 {message, response}
  ↓
Riverpod atualiza state
  ↓
UI re-renderiza com mensagens
```

### Fluxo de Pagamento

```
Usuário clica "Upgrade"
  ↓
PremiumPage.onUpgradePressed()
  ↓
StripeService.initPayment()
  ↓
Stripe Flutter SDK
  - Abre checkout Stripe
  - Usuário insere dados
  ↓
Stripe API processa pagamento
  ↓
Webhook: payment_intent.succeeded
  ↓
PaymentController.handleWebhook()
  ↓
PaymentService.updateSubscription()
  - Atualiza plano do usuário
  - Envia email de confirmação
  ↓
App notifica usuario
  ↓
UI mostra plano ativado
```

## Segurança

### Frontend
- Tokens armazenados em `FlutterSecureStorage`
- Certificado pinning (HTTP)
- Validação de input
- Logout ao expirar token

### Backend
- JWT com RS256
- Refresh tokens com expiration
- Rate limiting por IP e usuário
- Validação de entrada
- CORS configurado
- HTTPS obrigatório
- SQL queries parametrizadas

## Performance

### Frontend
- Image caching
- Lazy loading de lists
- Code splitting por feature
- Minificação (release build)
- Tree shaking

### Backend
- Database indexing
- Query optimization
- Caching com Redis (futuro)
- CDN para assets
- Connection pooling
