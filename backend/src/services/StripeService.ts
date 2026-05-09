import Stripe from 'stripe';
import { logger } from '../utils/logger';

interface CreateCheckoutSessionParams {
  userId: string;
  planId: string;
  email: string;
}

interface CreatePaymentIntentParams {
  userId: string;
  planId: string;
  amount: number;
}

export class StripeService {
  private stripe: Stripe;

  constructor() {
    this.stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
      apiVersion: '2023-10-16',
    });
  }

  /**
   * Create a Stripe customer for a user
   */
  async createCustomer(userId: string, email: string, fullName: string): Promise<string> {
    try {
      const customer = await this.stripe.customers.create({
        email,
        name: fullName,
        metadata: {
          userId,
        },
      });

      logger.info(`Stripe customer created: ${customer.id} for user ${userId}`);
      return customer.id;
    } catch (error) {
      logger.error('Error creating Stripe customer:', error);
      throw error;
    }
  }

  /**
   * Create a checkout session for subscription
   */
  async createCheckoutSession({
    userId,
    planId,
    email,
  }: CreateCheckoutSessionParams): Promise<string | null> {
    try {
      const planConfig = this.getPlanConfig(planId);
      if (!planConfig) {
        throw new Error(`Invalid plan ID: ${planId}`);
      }

      const session = await this.stripe.checkout.sessions.create({
        payment_method_types: ['card'],
        customer_email: email,
        mode: 'subscription',
        line_items: [
          {
            price_data: {
              currency: 'brl',
              product_data: {
                name: planConfig.name,
                description: planConfig.description,
                metadata: {
                  planId,
                },
              },
              unit_amount: planConfig.price,
              recurring: {
                interval: 'month',
                interval_count: 1,
              },
            },
            quantity: 1,
          },
        ],
        success_url: `${process.env.APP_URL}/payment-success?session_id={CHECKOUT_SESSION_ID}`,
        cancel_url: `${process.env.APP_URL}/payment-cancelled`,
        metadata: {
          userId,
          planId,
        },
      });

      logger.info(`Checkout session created: ${session.id} for user ${userId}`);
      return session.url;
    } catch (error) {
      logger.error('Error creating checkout session:', error);
      throw error;
    }
  }

  /**
   * Create a payment intent for one-time payment (PIX)
   */
  async createPaymentIntent({
    userId,
    planId,
    amount,
  }: CreatePaymentIntentParams): Promise<{
    clientSecret: string;
    amount: number;
  }> {
    try {
      const planConfig = this.getPlanConfig(planId);
      if (!planConfig) {
        throw new Error(`Invalid plan ID: ${planId}`);
      }

      const paymentIntent = await this.stripe.paymentIntents.create({
        amount,
        currency: 'brl',
        payment_method_types: ['pix'],
        metadata: {
          userId,
          planId,
        },
      });

      logger.info(`Payment intent created: ${paymentIntent.id} for user ${userId}`);
      return {
        clientSecret: paymentIntent.client_secret!,
        amount: paymentIntent.amount,
      };
    } catch (error) {
      logger.error('Error creating payment intent:', error);
      throw error;
    }
  }

  /**
   * Retrieve subscription details
   */
  async getSubscription(subscriptionId: string) {
    try {
      const subscription = await this.stripe.subscriptions.retrieve(
        subscriptionId
      );
      return subscription;
    } catch (error) {
      logger.error('Error retrieving subscription:', error);
      throw error;
    }
  }

  /**
   * Cancel a subscription
   */
  async cancelSubscription(
    subscriptionId: string,
    immediately: boolean = false
  ) {
    try {
      const subscription = await this.stripe.subscriptions.update(
        subscriptionId,
        {
          cancel_at_period_end: !immediately,
        }
      );

      if (immediately) {
        await this.stripe.subscriptions.del(subscriptionId);
      }

      logger.info(
        `Subscription cancelled: ${subscriptionId} (immediately: ${immediately})`
      );
      return subscription;
    } catch (error) {
      logger.error('Error cancelling subscription:', error);
      throw error;
    }
  }

  /**
   * Handle webhook events
   */
  async handleWebhookEvent(event: Stripe.Event): Promise<any> {
    try {
      switch (event.type) {
        case 'payment_intent.succeeded':
          return this.handlePaymentSucceeded(
            event.data.object as Stripe.PaymentIntent
          );

        case 'payment_intent.payment_failed':
          return this.handlePaymentFailed(
            event.data.object as Stripe.PaymentIntent
          );

        case 'customer.subscription.updated':
          return this.handleSubscriptionUpdated(
            event.data.object as Stripe.Subscription
          );

        case 'customer.subscription.deleted':
          return this.handleSubscriptionDeleted(
            event.data.object as Stripe.Subscription
          );

        case 'invoice.payment_succeeded':
          return this.handleInvoiceSucceeded(
            event.data.object as Stripe.Invoice
          );

        case 'invoice.payment_failed':
          return this.handleInvoiceFailed(
            event.data.object as Stripe.Invoice
          );

        default:
          logger.info(`Unhandled event type: ${event.type}`);
      }
    } catch (error) {
      logger.error('Error handling webhook event:', error);
      throw error;
    }
  }

  private async handlePaymentSucceeded(
    paymentIntent: Stripe.PaymentIntent
  ) {
    logger.info(`Payment succeeded: ${paymentIntent.id}`);
    // Update database with payment success
    // Send confirmation email
    // Send push notification
  }

  private async handlePaymentFailed(paymentIntent: Stripe.PaymentIntent) {
    logger.error(`Payment failed: ${paymentIntent.id}`);
    // Update database with payment failure
    // Send failure email
  }

  private async handleSubscriptionUpdated(
    subscription: Stripe.Subscription
  ) {
    logger.info(`Subscription updated: ${subscription.id}`);
    // Update subscription in database
  }

  private async handleSubscriptionDeleted(
    subscription: Stripe.Subscription
  ) {
    logger.info(`Subscription deleted: ${subscription.id}`);
    // Update subscription status to cancelled
    // Send cancellation email
  }

  private async handleInvoiceSucceeded(invoice: Stripe.Invoice) {
    logger.info(`Invoice payment succeeded: ${invoice.id}`);
    // Update invoice record
    // Send invoice email
  }

  private async handleInvoiceFailed(invoice: Stripe.Invoice) {
    logger.error(`Invoice payment failed: ${invoice.id}`);
    // Update invoice status
    // Send payment retry email
  }

  private getPlanConfig(planId: string) {
    const plans: Record<string, any> = {
      premium: {
        name: 'Nexo AI Premium',
        description: 'Acesso ilimitado a IA, memória e tarefas',
        price: 1990, // R$19.90 in cents
      },
      pro: {
        name: 'Nexo AI Pro',
        description: 'Tudo do Premium + automações avançadas e WhatsApp',
        price: 4990, // R$49.90 in cents
      },
    };

    return plans[planId];
  }
}
