# Nexo AI - Sua Segunda Mente 🧠

Um assistente pessoal inteligente estilo ChatGPT focado em organização da vida digital, produtividade, memória pessoal e rotina automática.

## 🎯 Visão Geral

Nexo AI é um aplicativo mobile premium que funciona como uma "segunda mente" do usuário, ajudando na organização de:
- Tarefas
- Ideias
- Lembretes
- Rotina
- Links
- Anotações
- Metas
- Calendário
- Gastos
- Informações importantes

## 🏗️ Arquitetura

```
nexo-ai/
├── frontend/              # Aplicativo Flutter
├── backend/               # API Node.js/Express
├── database/              # Scripts PostgreSQL
├── docs/                  # Documentação
└── .github/               # GitHub Actions
```

## 🛠️ Tecnologias

### Frontend
- **Flutter 3.x** - UI multiplataforma
- **Dart** - Linguagem
- **Riverpod** - State Management
- **Dio** - HTTP Client
- **Supabase Flutter** - Auth e Real-time
- **Firebase** - Push Notifications
- **Stripe Flutter** - Pagamentos

### Backend
- **Node.js 20.x** - Runtime
- **Express.js** - Framework Web
- **PostgreSQL** - Banco de dados
- **Supabase** - Auth e DB Hosted
- **OpenAI API** - IA/LLM
- **Pinecone/Supabase Vector** - Vector DB
- **JWT** - Autenticação
- **Stripe** - Pagamentos

### Banco de Dados
- **PostgreSQL 15+**
- **Supabase** (alternativa gerenciada)
- **Vector Store** para embeddings

## 📋 Funcionalidades

### 1. Chat IA Principal
- Interface estilo ChatGPT
- Histórico de conversas
- Memória contextual
- Sugestões automáticas
- Busca inteligente

### 2. Memória Inteligente
- Armazenamento de links, textos, ideias
- Tags automáticas via IA
- Busca por embeddings
- Organização por contexto

### 3. Organização Automática
- Criação automática de tarefas
- Detecção de datas
- Lembretes inteligentes
- Resumo do dia
- Priorização automática

### 4. Dashboard
- Saudação personalizada
- Resumo do dia
- Tarefas prioritárias
- Calendário integrado
- Estatísticas pessoais

### 5. Sistema de Pagamentos
- Stripe, Google Play Billing, Apple IAP
- PIX e cartão de crédito
- Teste gratuito
- Cancelamento fácil

## 💳 Planos

### Gratuito
- Limite de mensagens/dia
- Memória limitada
- Poucas integrações

### Premium - R$19,90/mês ou R$199/ano
- IA ilimitada
- Memória ilimitada
- Modo voz
- Sincronização cloud
- Múltiplos dispositivos

### Pro - R$49,90/mês
- Tudo do Premium
- Automações avançadas
- Integração WhatsApp
- IA personalizada
- Análises comportamentais

## 🚀 Getting Started

### Requisitos
- Flutter 3.x
- Node.js 20.x
- PostgreSQL 15+
- Chaves API (OpenAI, Stripe, etc)

### Setup Frontend
```bash
cd frontend
flutter pub get
flutter run
```

### Setup Backend
```bash
cd backend
npm install
npm run dev
```

### Variáveis de Ambiente

Veja `.env.example` em cada pasta.

## 📚 Documentação

- [API Documentation](./docs/API.md)
- [Database Schema](./docs/DATABASE.md)
- [Design System](./docs/DESIGN.md)
- [Payment Integration](./docs/PAYMENTS.md)
- [Architecture](./docs/ARCHITECTURE.md)
- [Project Structure](./docs/PROJECT_STRUCTURE.md)

## 👤 Autor

Desenvolvido por: @carlossilveira4m-png

## 📄 Licença

MIT
