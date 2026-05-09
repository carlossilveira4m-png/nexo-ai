import { Router, Request, Response } from 'express';
import { PaymentController } from '../controllers/PaymentController';
import { authenticate } from '../middleware/auth';

const router = Router();
const paymentController = new PaymentController();

/**
 * POST /api/payments/stripe/checkout
 * Create a Stripe checkout session
 */
router.post(
  '/stripe/checkout',
  authenticate,
  (req: Request, res: Response) => paymentController.createCheckoutSession(req, res)
);

/**
 * POST /api/payments/pix
 * Create a PIX payment intent
 */
router.post(
  '/pix',
  authenticate,
  (req: Request, res: Response) => paymentController.createPixPayment(req, res)
);

/**
 * POST /api/payments/google-play/verify
 * Verify Google Play purchase
 */
router.post(
  '/google-play/verify',
  authenticate,
  (req: Request, res: Response) => paymentController.verifyGooglePlayPurchase(req, res)
);

/**
 * POST /api/payments/apple/verify
 * Verify Apple purchase
 */
router.post(
  '/apple/verify',
  authenticate,
  (req: Request, res: Response) => paymentController.verifyApplePurchase(req, res)
);

/**
 * POST /api/payments/webhook
 * Stripe webhook endpoint
 */
router.post(
  '/webhook',
  (req: Request, res: Response) => paymentController.handleStripeWebhook(req, res)
);

/**
 * GET /api/payments/subscription
 * Get user subscription
 */
router.get(
  '/subscription',
  authenticate,
  (req: Request, res: Response) => paymentController.getSubscription(req, res)
);

/**
 * POST /api/payments/cancel-subscription
 * Cancel user subscription
 */
router.post(
  '/cancel-subscription',
  authenticate,
  (req: Request, res: Response) => paymentController.cancelSubscription(req, res)
);

export default router;
