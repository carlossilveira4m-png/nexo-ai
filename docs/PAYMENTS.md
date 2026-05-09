# Sistema de Pagamentos - Nexo AI

## 📊 Overview

Nexo AI integra múltiplos gateways de pagamento para oferecer flexibilidade aos usuários:

- **Stripe** - Cartão de crédito (global)
- **Google Play Billing** - Android
- **Apple In-App Purchase** - iOS
- **PIX** - Brasil (via Stripe)

## 💳 Planos e Preços

### Gratuito (Free)
- ✅ 20 mensagens IA/dia
- ✅ Memória limitada a 50 items
- ✅ 5 tarefas ativas
- ✅ Anúncios leves
- ❌ Modo voz
- ❌ Sincronização cloud
- ❌ Integrações

### Premium
- **Preço**: R$19,90/mês ou R$199/ano (2 meses grátis)
- ✅ IA ilimitada
- ✅ Memória ilimitada
- ✅ Tarefas ilimitadas
- ✅ Modo voz
- ✅ Sincronização cloud
- ✅ Múltiplos dispositivos
- ✅ Sem anúncios
- ✅ Personalização completa

### Pro
- **Preço**: R$49,90/mês
- ✅ Tudo do Premium
- ✅ Assistente avançado
- ✅ Automações inteligentes
- ✅ Integração WhatsApp
- ✅ IA personalizada por comportamento
- ✅ Análises comportamentais
- ✅ Exportação de dados ilimitada
- ✅ Prioridade de suporte

## 🏗️ Arquitetura de Pagamentos

### Frontend Flow

```
PremiumPage
  ↓
SelectPlan()
  ↓
PaymentService.initiate()
  ├─ iOS → Apple SKPaymentQueue
  ├─ Android → Google Play Billing
  └─ Web → Stripe Checkout
  ↓
PaymentResult
  ├─ Success → updateSubscription()
  ├─ Pending → awaitConfirmation()
  └─ Cancelled → dismissModal()
```

### Backend Flow

```
Payment Webhook
  ↓
StripeController.handleWebhook()
  ↓
VerifySignature()
  ↓
PaymentService.processPayment()
  ├─ Update user.plan
  ├─ Create subscription record
  ├─ Send confirmation email
  └─ Trigger analytics
  ↓
NotifyApp()
  ├─ Push notification
  └─ Update cached subscription
```

## 🔐 Integração Stripe

### Setup

1. **Conta Stripe**
   - Criar em https://dashboard.stripe.com
   - Ativar modo Live
   - Copiar chaves (Public Key, Secret Key)

2. **Webhooks**
   - Adicionar endpoint: `https://seu-dominio.com/api/payments/webhook`
   - Eventos subscritos:
     - `payment_intent.succeeded`
     - `payment_intent.payment_failed`
     - `customer.subscription.updated`
     - `customer.subscription.deleted`
     - `invoice.payment_succeeded`
     - `invoice.payment_failed`

## 🔄 Fluxo de Renovação

### Automático (Stripe)

```
Data da renovação
  ↓
Stripe cobra automaticamente
  ↓
invoice.payment_succeeded
  ↓
Backend atualiza subscription
  ↓
Push notification para usuário
```

### Cancelamento

```
Usuário clica "Cancelar assinatura"
  ↓
Frontend faz POST /api/payments/cancel-subscription
  ↓
Backend remove subscription no Stripe
  ↓
Atualiza status para 'cancelled'
  ↓
Envia email de confirmação
```

## 📊 Banco de Dados

### Tabelas

```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  plan TEXT NOT NULL (free|premium|pro),
  status TEXT NOT NULL (active|cancelled|expired),
  stripe_subscription_id VARCHAR UNIQUE,
  stripe_customer_id VARCHAR,
  payment_method TEXT,
  current_period_start TIMESTAMP,
  current_period_end TIMESTAMP,
  cancel_at_period_end BOOLEAN DEFAULT false,
  cancellation_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE payments (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  subscription_id UUID REFERENCES subscriptions(id),
  stripe_payment_id VARCHAR UNIQUE,
  amount INT NOT NULL,
  currency VARCHAR DEFAULT 'BRL',
  status TEXT NOT NULL (pending|succeeded|failed|refunded),
  payment_method TEXT,
  description VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE payment_methods (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  stripe_payment_method_id VARCHAR UNIQUE,
  type TEXT (card|pix|bank_account),
  card_brand VARCHAR,
  card_last_4 VARCHAR,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## ✅ Testes

### Stripe Test Cards

```
✅ Sucesso: 4242 4242 4242 4242
❌ Falha: 4000 0000 0000 0002
⚠️ 3D Secure: 4000 0000 0000 3220
```

## 🔒 Segurança

- ✅ Nunca expor chaves Stripe no client
- ✅ Sempre verificar assinatura do webhook
- ✅ Validar receipt no servidor (Apple, Google)
- ✅ HTTPS obrigatório
- ✅ Rate limiting em endpoints de pagamento
- ✅ Logs de todas as transações
- ✅ Audit trail completo
