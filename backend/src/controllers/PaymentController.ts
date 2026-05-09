import { Request, Response } from 'express';
import { logger } from '../utils/logger';
import { StripeService } from '../services/StripeService';
import { GooglePlayBillingService } from '../services/GooglePlayBillingService';
import { AppleBillingService } from '../services/AppleBillingService';
import Stripe from 'stripe';

export class PaymentController {
  private stripeService: StripeService;
  private googlePlayBillingService: GooglePlayBillingService;
  private appleBillingService: AppleBillingService;

  constructor() {
    this.stripeService = new StripeService();
    this.googlePlayBillingService = new GooglePlayBillingService();
    this.appleBillingService = new AppleBillingService();
  }

  /**
   * Create Stripe checkout session
   */
  async createCheckoutSession(req: Request, res: Response): Promise<void> {
    try {
      const { planId } = req.body;
      const userId = req.user?.id;
      const email = req.user?.email;

      if (!userId || !email || !planId) {
        res.status(400).json({
          error: 'Missing required fields: userId, email, planId',
        });
        return;
      }

      const checkoutUrl = await this.stripeService.createCheckoutSession({
        userId,
        planId,
        email,
      });

      res.json({ url: checkoutUrl });
    } catch (error) {
      logger.error('Error creating checkout session:', error);
      res.status(500).json({ error: 'Failed to create checkout session' });
    }
  }

  /**
   * Create PIX payment intent
   */
  async createPixPayment(req: Request, res: Response): Promise<void> {
    try {
      const { planId } = req.body;
      const userId = req.user?.id;

      if (!userId || !planId) {
        res.status(400).json({
          error: 'Missing required fields: userId, planId',
        });
        return;
      }

      const planConfig = this.getPlanConfig(planId);
      if (!planConfig) {
        res.status(400).json({ error: 'Invalid plan ID' });
        return;
      }

      const paymentIntent = await this.stripeService.createPaymentIntent({
        userId,
        planId,
        amount: planConfig.price,
      });

      res.json(paymentIntent);
    } catch (error) {
      logger.error('Error creating PIX payment:', error);
      res.status(500).json({ error: 'Failed to create PIX payment' });
    }
  }

  /**
   * Verify Google Play purchase
   */
  async verifyGooglePlayPurchase(req: Request, res: Response): Promise<void> {
    try {
      const { packageName, productId, token } = req.body;
      const userId = req.user?.id;

      if (!userId || !packageName || !productId || !token) {
        res.status(400).json({
          error: 'Missing required fields',
        });
        return;
      }

      const purchaseDetails =
        await this.googlePlayBillingService.verifyPurchase(
          packageName,
          productId,
          token
        );

      // Update user subscription in database
      // TODO: Update subscription in database

      res.json({
        success: true,
        purchaseDetails,
      });
    } catch (error) {
      logger.error('Error verifying Google Play purchase:', error);
      res.status(500).json({ error: 'Failed to verify Google Play purchase' });
    }
  }

  /**
   * Verify Apple purchase
   */
  async verifyApplePurchase(req: Request, res: Response): Promise<void> {
    try {
      const { receipt } = req.body;
      const userId = req.user?.id;

      if (!userId || !receipt) {
        res.status(400).json({
          error: 'Missing required fields: userId, receipt',
        });
        return;
      }

      const receiptData =
        await this.appleBillingService.verifyReceipt(receipt);
      const isActive = await this.appleBillingService.isSubscriptionActive(
        receiptData
      );

      if (!isActive) {
        res.status(400).json({
          error: 'Subscription is not active',
        });
        return;
      }

      // Update user subscription in database
      // TODO: Update subscription in database

      res.json({
        success: true,
        receiptData,
        isActive,
      });
    } catch (error) {
      logger.error('Error verifying Apple purchase:', error);
      res.status(500).json({ error: 'Failed to verify Apple purchase' });
    }
  }

  /**
   * Handle Stripe webhook
   */
  async handleStripeWebhook(req: Request, res: Response): Promise<void> {
    try {
      const signature = req.headers['stripe-signature'] as string;
      const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

      let event: Stripe.Event;

      try {
        const stripe = new (require('stripe'))(process.env.STRIPE_SECRET_KEY!);
        event = stripe.webhooks.constructEvent(
          req.body,
          signature,
          webhookSecret
        );
      } catch (err) {
        res.status(400).json({ error: 'Invalid webhook signature' });
        return;
      }

      // Process webhook event
      await this.stripeService.handleWebhookEvent(event);

      res.json({ received: true });
    } catch (error) {
      logger.error('Error handling Stripe webhook:', error);
      res.status(500).json({ error: 'Failed to handle webhook' });
    }
  }

  /**
   * Get user subscription
   */
  async getSubscription(req: Request, res: Response): Promise<void> {
    try {
      const userId = req.user?.id;

      if (!userId) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      // TODO: Get subscription from database
      const subscription = {
        id: 'sub_123',
        plan: 'premium',
        status: 'active',
        currentPeriodEnd: new Date(),
      };

      res.json(subscription);
    } catch (error) {
      logger.error('Error getting subscription:', error);
      res.status(500).json({ error: 'Failed to get subscription' });
    }
  }

  /**
   * Cancel subscription
   */
  async cancelSubscription(req: Request, res: Response): Promise<void> {
    try {
      const userId = req.user?.id;
      const { subscriptionId } = req.body;

      if (!userId || !subscriptionId) {
        res.status(400).json({
          error: 'Missing required fields: subscriptionId',
        });
        return;
      }

      // Cancel subscription in Stripe
      await this.stripeService.cancelSubscription(subscriptionId);

      // Update database
      // TODO: Update subscription status to cancelled

      res.json({ success: true });
    } catch (error) {
      logger.error('Error cancelling subscription:', error);
      res.status(500).json({ error: 'Failed to cancel subscription' });
    }
  }

  private getPlanConfig(planId: string) {
    const plans: Record<string, any> = {
      premium: {
        name: 'Nexo AI Premium',
        price: 1990,
      },
      pro: {
        name: 'Nexo AI Pro',
        price: 4990,
      },
    };

    return plans[planId];
  }
}
