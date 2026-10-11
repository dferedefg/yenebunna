/**
 * Idempotent Back4App Parse Schema Provisioner for Yene Bunna (የኔ ቡና).
 * Safe to run repeatedly: inspects `GET /schemas/<className>` first,
 * creates missing classes via `POST`, and appends only missing fields via `PUT`.
 */

const CLASSES = {
  order: 'MarketplaceOrder',
  review: 'MarketplaceReview',
  premiumCoffee: 'PremiumCoffee',
  cartItem: 'CartItem',
  address: 'Address',
  paymentMethod: 'PaymentMethod',
  favoriteItem: 'FavoriteItem',
  notification: 'Notification',
};

const SCHEMA_DEFINITIONS = {
  [CLASSES.premiumCoffee]: {
    beanId: { type: 'String' },
    idempotencyKey: { type: 'String' },
    name: { type: 'String' },
    amharicName: { type: 'String' },
    category: { type: 'String' },
    region: { type: 'String' },
    subRegion: { type: 'String' },
    elevation: { type: 'String' },
    processMethod: { type: 'String' },
    varietal: { type: 'String' },
    cupScore: { type: 'Number' },
    pricePerKgETB: { type: 'Number' },
    roasterName: { type: 'String' },
    defaultRoast: { type: 'String' },
    flavorNotes: { type: 'Array' },
  },
  [CLASSES.order]: {
    orderNumber: { type: 'String' },
    idempotencyKey: { type: 'String' },
    totalETB: { type: 'Number' },
    status: { type: 'String' },
    roasteryName: { type: 'String' },
    destinationAddress: { type: 'String' },
    batchCode: { type: 'String' },
    itemsCount: { type: 'Number' },
    paymentReference: { type: 'String' },
    paymentMethod: { type: 'String' },
  },
  [CLASSES.review]: {
    beanId: { type: 'String' },
    idempotencyKey: { type: 'String' },
    authorName: { type: 'String' },
    rating: { type: 'Number' },
    brewMethod: { type: 'String' },
    comment: { type: 'String' },
    createdAtLabel: { type: 'String' },
  },
  [CLASSES.address]: {
    idempotencyKey: { type: 'String' },
    label: { type: 'String' },
    subCity: { type: 'String' },
    woreda: { type: 'String' },
    streetAndGateNotes: { type: 'String' },
    isDefault: { type: 'Boolean' },
  },
  [CLASSES.paymentMethod]: {
    idempotencyKey: { type: 'String' },
    provider: { type: 'String' },
    accountHolder: { type: 'String' },
    maskedAccount: { type: 'String' },
    isDefault: { type: 'Boolean' },
  },
  [CLASSES.favoriteItem]: {
    beanId: { type: 'String' },
    idempotencyKey: { type: 'String' },
    savedAt: { type: 'String' },
  },
};

async function ensureIdempotentSchema({ serverUrl, appId, masterKey }) {
  if (!serverUrl || !appId || !masterKey) {
    return { status: 'skipped-missing-master-key', classes: Object.values(CLASSES) };
  }

  const headers = {
    'X-Parse-Application-Id': appId,
    'X-Parse-Master-Key': masterKey,
    'Content-Type': 'application/json',
  };

  const summary = [];
  for (const [className, fields] of Object.entries(SCHEMA_DEFINITIONS)) {
    const getRes = await fetch(`${serverUrl}/schemas/${className}`, {
      method: 'GET',
      headers,
    });

    if (getRes.status === 404) {
      await fetch(`${serverUrl}/schemas/${className}`, {
        method: 'POST',
        headers,
        body: JSON.stringify({ className, fields }),
      });
      summary.push({ className, action: 'created' });
    } else if (getRes.ok) {
      const existing = await getRes.json();
      const existingFields = existing.fields || {};
      const missingFields = {};
      for (const [fieldName, spec] of Object.entries(fields)) {
        if (!existingFields[fieldName]) {
          missingFields[fieldName] = spec;
        }
      }
      if (Object.keys(missingFields).length > 0) {
        await fetch(`${serverUrl}/schemas/${className}`, {
          method: 'PUT',
          headers,
          body: JSON.stringify({ className, fields: missingFields }),
        });
        summary.push({ className, action: 'updated-missing-fields' });
      } else {
        summary.push({ className, action: 'noop-already-aligned' });
      }
    }
  }
  return { status: 'ok', summary };
}

module.exports = { CLASSES, SCHEMA_DEFINITIONS, ensureIdempotentSchema };
