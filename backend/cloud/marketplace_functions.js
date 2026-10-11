/**
 * Back4App Cloud Code functions & Idempotent beforeSave triggers
 * for the Yene Bunna (የኔ ቡና) Ethiopian Coffee Marketplace app.
 * Matches `ParseClasses` in `lib/core/config/parse_classes.dart`.
 */

const ORDER_CLASS = 'MarketplaceOrder';
const REVIEW_CLASS = 'MarketplaceReview';
const COFFEE_CLASS = 'PremiumCoffee';
const FAVORITE_CLASS = 'FavoriteItem';

Parse.Cloud.define('getMarketplaceBeanSummary', async (request) => {
  const { beanId } = request.params;
  const query = new Parse.Query(REVIEW_CLASS);
  if (beanId) {
    query.equalTo('beanId', beanId);
  }
  const reviews = await query.find({ useMasterKey: true });
  const count = reviews.length;
  const avgRating =
    count === 0
      ? 5.0
      : reviews.reduce((sum, r) => sum + (r.get('rating') || 5), 0) / count;

  return {
    beanId: beanId || 'all',
    reviewsCount: count,
    averageRating: Number(avgRating.toFixed(2)),
  };
});

/**
 * Idempotent beforeSave guard for PremiumCoffee catalog lots (unique by `beanId`).
 */
Parse.Cloud.beforeSave(COFFEE_CLASS, async (request) => {
  const coffee = request.object;
  if (!coffee.isNew()) return;

  const beanId = coffee.get('beanId');
  if (!beanId) return;

  const existingQuery = new Parse.Query(COFFEE_CLASS);
  existingQuery.equalTo('beanId', beanId);
  const existing = await existingQuery.first({ useMasterKey: true });
  if (existing) {
    throw new Parse.Error(
      Parse.Error.DUPLICATE_VALUE,
      `Idempotent Guard: PremiumCoffee lot '${beanId}' already exists (objectId=${existing.id}). Use PUT to update in-place.`
    );
  }
});

/**
 * Idempotent beforeSave guard for MarketplaceOrder (unique by `orderNumber` or `idempotencyKey`).
 */
Parse.Cloud.beforeSave(ORDER_CLASS, async (request) => {
  const order = request.object;
  if (!order.get('status')) {
    order.set('status', 'Roasting');
  }
  if (!order.get('batchCode')) {
    order.set('batchCode', `BATCH-ETH-${Date.now().toString().slice(-4)}`);
  }

  if (order.isNew()) {
    const orderNumber = order.get('orderNumber');
    if (orderNumber) {
      const existingQuery = new Parse.Query(ORDER_CLASS);
      existingQuery.equalTo('orderNumber', orderNumber);
      const existing = await existingQuery.first({ useMasterKey: true });
      if (existing) {
        throw new Parse.Error(
          Parse.Error.DUPLICATE_VALUE,
          `Idempotent Guard: MarketplaceOrder '${orderNumber}' already exists (objectId=${existing.id}).`
        );
      }
    }
  }
});

/**
 * Idempotent beforeSave guard for MarketplaceReview (unique by `idempotencyKey`).
 */
Parse.Cloud.beforeSave(REVIEW_CLASS, async (request) => {
  const review = request.object;
  if (!review.isNew()) return;

  const idempotencyKey = review.get('idempotencyKey');
  if (idempotencyKey) {
    const existingQuery = new Parse.Query(REVIEW_CLASS);
    existingQuery.equalTo('idempotencyKey', idempotencyKey);
    const existing = await existingQuery.first({ useMasterKey: true });
    if (existing) {
      throw new Parse.Error(
        Parse.Error.DUPLICATE_VALUE,
        `Idempotent Guard: MarketplaceReview with key '${idempotencyKey}' already exists.`
      );
    }
  }
});

/**
 * Idempotent beforeSave guard for FavoriteItem (unique by `idempotencyKey`).
 */
Parse.Cloud.beforeSave(FAVORITE_CLASS, async (request) => {
  const fav = request.object;
  if (!fav.isNew()) return;

  const idempotencyKey = fav.get('idempotencyKey');
  if (idempotencyKey) {
    const existingQuery = new Parse.Query(FAVORITE_CLASS);
    existingQuery.equalTo('idempotencyKey', idempotencyKey);
    const existing = await existingQuery.first({ useMasterKey: true });
    if (existing) {
      throw new Parse.Error(
        Parse.Error.DUPLICATE_VALUE,
        `Idempotent Guard: FavoriteItem '${idempotencyKey}' already exists.`
      );
    }
  }
});
