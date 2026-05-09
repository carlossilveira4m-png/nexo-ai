import { logger } from '../utils/logger';

interface AppleVerificationResponse {
  receipt?: {
    bundle_id: string;
    product_id: string;
    purchase_date_ms: number;
    original_purchase_date_ms: number;
  };
  status: number;
}

export class AppleBillingService {
  private sandboxUrl = 'https://sandbox.itunes.apple.com/verifyReceipt';
  private productionUrl = 'https://buy.itunes.apple.com/verifyReceipt';
  private sharedSecret = process.env.APPLE_SHARED_SECRET!;

  /**
   * Verify Apple receipt
   */
  async verifyReceipt(receiptData: string): Promise<any> {
    try {
      // Try production first
      let response = await this.verifyWithApple(
        this.productionUrl,
        receiptData
      );

      // If production returns status 21007 or 21008, try sandbox
      if (response.status === 21007 || response.status === 21008) {
        response = await this.verifyWithApple(this.sandboxUrl, receiptData);
      }

      if (response.status !== 0) {
        throw new Error(
          `Apple verification failed with status: ${response.status}`
        );
      }

      logger.info('Apple receipt verified successfully');
      return response.receipt;
    } catch (error) {
      logger.error('Error verifying Apple receipt:', error);
      throw error;
    }
  }

  /**
   * Verify with Apple servers
   */
  private async verifyWithApple(
    url: string,
    receiptData: string
  ): Promise<AppleVerificationResponse> {
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          'receipt-data': receiptData,
          password: this.sharedSecret,
        }),
      });

      if (!response.ok) {
        throw new Error(`Apple verification request failed: ${response.status}`);
      }

      const data = (await response.json()) as AppleVerificationResponse;
      return data;
    } catch (error) {
      logger.error('Error verifying with Apple:', error);
      throw error;
    }
  }

  /**
   * Check if subscription is active
   */
  async isSubscriptionActive(receipt: any): Promise<boolean> {
    try {
      if (!receipt || !receipt.bundle_id) {
        return false;
      }

      const expiresDate = new Date(parseInt(receipt.expires_date_ms, 10));
      const now = new Date();

      return expiresDate > now;
    } catch (error) {
      logger.error('Error checking subscription status:', error);
      return false;
    }
  }
}
