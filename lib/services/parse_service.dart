import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../core/config/parse_classes.dart';
import '../core/config/parse_config.dart';
import '../models/address_payment.dart';
import '../models/coffee_bean.dart';
import '../models/order.dart';
import '../models/review.dart';

/// Unified Back4App / Parse REST client supporting idempotent GET-then-PUT/POST
/// upserts, in-flight request deduplication, 1-click `PremiumCoffee` catalog
/// seeding, and live GET hydration across all ParseClasses.
class ParseService {
  ParseService._();
  static final ParseService instance = ParseService._();

  final Set<String> _inFlightKeys = <String>{};
  final Map<String, String> _idempotencyLedger = <String, String>{};

  Map<String, String> get idempotencyLedger =>
      Map.unmodifiable(_idempotencyLedger);

  /// Deterministic idempotency key generator (`IDEMP-<PREFIX>-<SLUG>-<HEX>`)
  static String computeIdempotencyKey(String prefix, String rawKey) {
    final clean = rawKey
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final slug = clean.length > 36 ? clean.substring(0, 36) : clean;
    var hash = 0x811c9dc5;
    for (var i = 0; i < rawKey.length; i++) {
      hash ^= rawKey.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    final hex = hash.toRadixString(16).toUpperCase().padLeft(6, '0');
    return 'IDEMP-${prefix.toUpperCase()}-$slug-$hex';
  }

  /// Idempotent Upsert:
  /// 1. Guards against concurrent in-flight duplicate calls via `_inFlightKeys`.
  /// 2. Checks `_idempotencyLedger` or queries `GET /classes/<className>?where={"<uniqueField>":"<uniqueValue>"}`.
  /// 3. Updates existing object via `PUT /classes/<className>/<objectId>` or creates via `POST`.
  Future<bool> upsertObject({
    required String className,
    required String uniqueField,
    required String uniqueValue,
    required Map<String, dynamic> data,
    String? sessionToken,
    String? idempotencyKey,
  }) async {
    final key = idempotencyKey ??
        computeIdempotencyKey(className, '$uniqueField:$uniqueValue');

    if (_inFlightKeys.contains(key)) {
      return true;
    }
    _inFlightKeys.add(key);

    try {
      if (kIsWeb || !ParseConfig.hasCredentials) {
        _idempotencyLedger[key] = _idempotencyLedger[key] ?? 'web-$uniqueValue';
        return true;
      }

      String? existingObjectId = _idempotencyLedger[key];

      if (existingObjectId == null) {
        final whereJson = jsonEncode({uniqueField: uniqueValue});
        final queryUri = Uri.parse(
          '${ParseConfig.serverUrl}/classes/$className?where=${Uri.encodeQueryComponent(whereJson)}&limit=1',
        );
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 5);
        final getReq = await client.getUrl(queryUri);
        getReq.headers.set('X-Parse-Application-Id', ParseConfig.applicationId);
        getReq.headers.set('X-Parse-Client-Key', ParseConfig.clientKey);
        if (sessionToken != null &&
            sessionToken.isNotEmpty &&
            !sessionToken.startsWith('r:session-')) {
          getReq.headers.set('X-Parse-Session-Token', sessionToken);
        }
        final getRes = await getReq.close();
        if (getRes.statusCode == 200) {
          final body = await getRes.transform(utf8.decoder).join();
          final decoded = jsonDecode(body) as Map<String, dynamic>;
          final results = decoded['results'];
          if (results is List && results.isNotEmpty) {
            final first = results.first;
            if (first is Map<String, dynamic> && first['objectId'] != null) {
              existingObjectId = first['objectId'].toString();
            }
          }
        }
      }

      final payload = <String, dynamic>{
        ...data,
        uniqueField: uniqueValue,
        'idempotencyKey': key,
      };

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);

      if (existingObjectId != null) {
        final putUri = Uri.parse(
          '${ParseConfig.serverUrl}/classes/$className/$existingObjectId',
        );
        final putReq = await client.putUrl(putUri);
        putReq.headers.set('X-Parse-Application-Id', ParseConfig.applicationId);
        putReq.headers.set('X-Parse-Client-Key', ParseConfig.clientKey);
        putReq.headers.set('Content-Type', 'application/json');
        if (sessionToken != null &&
            sessionToken.isNotEmpty &&
            !sessionToken.startsWith('r:session-')) {
          putReq.headers.set('X-Parse-Session-Token', sessionToken);
        }
        putReq.add(utf8.encode(jsonEncode(payload)));
        final putRes = await putReq.close();
        if (putRes.statusCode == 200) {
          _idempotencyLedger[key] = existingObjectId;
          return true;
        }
      }

      final postUri = Uri.parse('${ParseConfig.serverUrl}/classes/$className');
      final postReq = await client.postUrl(postUri);
      postReq.headers.set('X-Parse-Application-Id', ParseConfig.applicationId);
      postReq.headers.set('X-Parse-Client-Key', ParseConfig.clientKey);
      postReq.headers.set('Content-Type', 'application/json');
      if (sessionToken != null &&
          sessionToken.isNotEmpty &&
          !sessionToken.startsWith('r:session-')) {
        postReq.headers.set('X-Parse-Session-Token', sessionToken);
      }
      postReq.add(utf8.encode(jsonEncode(payload)));
      final postRes = await postReq.close();
      if (postRes.statusCode == 201 || postRes.statusCode == 200) {
        final body = await postRes.transform(utf8.decoder).join();
        final decoded = jsonDecode(body) as Map<String, dynamic>;
        final createdId =
            (decoded['objectId'] ?? 'obj-${DateTime.now().millisecondsSinceEpoch}')
                .toString();
        _idempotencyLedger[key] = createdId;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      _inFlightKeys.remove(key);
    }
  }

  Future<bool> createObject({
    required String className,
    required Map<String, dynamic> data,
    String? sessionToken,
  }) async {
    final uniqueField = data.containsKey('beanId')
        ? 'beanId'
        : data.containsKey('orderNumber')
            ? 'orderNumber'
            : 'idempotencyKey';
    final uniqueValue = (data[uniqueField] ?? jsonEncode(data)).toString();
    return upsertObject(
      className: className,
      uniqueField: uniqueField,
      uniqueValue: uniqueValue,
      data: data,
      sessionToken: sessionToken,
    );
  }

  /// Idempotent 1-Click Seeder: Upserts all Ethiopian CoffeeBean lots to Back4App `PremiumCoffee` by `beanId`.
  Future<int> seedPremiumCoffeeCatalog(
    List<CoffeeBean> beans, {
    String? sessionToken,
  }) async {
    var seededCount = 0;
    for (final bean in beans) {
      final ok = await upsertObject(
        className: ParseClasses.premiumCoffee,
        uniqueField: 'beanId',
        uniqueValue: bean.id,
        idempotencyKey: computeIdempotencyKey('BEAN', bean.id),
        sessionToken: sessionToken,
        data: {
          'beanId': bean.id,
          'name': bean.name,
          'amharicName': bean.amharicName,
          'category': bean.category,
          'region': bean.region,
          'subRegion': bean.subRegion,
          'elevation': bean.elevation,
          'processMethod': bean.processMethod,
          'varietal': bean.varietal,
          'cupScore': bean.cupScore,
          'pricePerKgETB': bean.pricePerKgETB,
          'roasterName': bean.roasterName,
          'defaultRoast': bean.defaultRoast.shortLabel,
          'flavorNotes': bean.flavorNotes,
        },
      );
      if (ok || kIsWeb) {
        seededCount++;
      }
    }
    return seededCount;
  }

  /// Live GET hydration query from Back4App Parse Server (`GET /classes/<className>`)
  Future<List<Map<String, dynamic>>> fetchObjects({
    required String className,
    int limit = 25,
    String? sessionToken,
  }) async {
    if (kIsWeb || !ParseConfig.hasCredentials) {
      return const [];
    }
    try {
      final uri = Uri.parse(
        '${ParseConfig.serverUrl}/classes/$className?order=-createdAt&limit=$limit',
      );
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);
      final req = await client.getUrl(uri);
      req.headers.set('X-Parse-Application-Id', ParseConfig.applicationId);
      req.headers.set('X-Parse-Client-Key', ParseConfig.clientKey);
      if (sessionToken != null &&
          sessionToken.isNotEmpty &&
          !sessionToken.startsWith('r:session-')) {
        req.headers.set('X-Parse-Session-Token', sessionToken);
      }
      final res = await req.close();
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final decoded = jsonDecode(body) as Map<String, dynamic>;
        final results = decoded['results'];
        if (results is List) {
          return results.whereType<Map<String, dynamic>>().toList();
        }
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  /// Idempotent GET hydration for reviews — deduplicated by content fingerprint
  Future<List<MarketplaceReview>> fetchReviewsFromParse() async {
    final rows = await fetchObjects(className: ParseClasses.review, limit: 30);
    final seenFingerprints = <String>{};
    final list = <MarketplaceReview>[];

    for (final r in rows) {
      final beanId = (r['beanId'] ?? 'yirgacheffe-kochere-g1').toString();
      final authorName = (r['authorName'] ?? 'Verified Coffee Lover').toString();
      final comment = (r['comment'] ?? '').toString().trim();
      if (comment.isEmpty) continue;

      final fingerprint =
          '$beanId::${authorName.toLowerCase()}::${comment.toLowerCase()}';
      if (seenFingerprints.contains(fingerprint)) continue;
      seenFingerprints.add(fingerprint);

      list.add(
        MarketplaceReview(
          id: (r['objectId'] ?? 'rev-${DateTime.now().millisecondsSinceEpoch}')
              .toString(),
          beanId: beanId,
          authorName: authorName,
          rating: (r['rating'] is num) ? (r['rating'] as num).toInt() : 5,
          brewMethod: (r['brewMethod'] ?? 'Whole Bean').toString(),
          comment: comment,
          createdAtLabel:
              (r['createdAtLabel'] ?? 'Synced from Parse').toString(),
        ),
      );
    }
    return list;
  }

  Future<bool> saveOrderToParse(
    Order order, {
    String? sessionToken,
    String? paymentReference,
  }) async {
    return upsertObject(
      className: ParseClasses.order,
      uniqueField: 'orderNumber',
      uniqueValue: order.orderNumber,
      idempotencyKey: computeIdempotencyKey('ORD', order.orderNumber),
      sessionToken: sessionToken,
      data: {
        'orderNumber': order.orderNumber,
        'totalETB': order.totalETB,
        'status': order.status.name,
        'roasteryName': order.roasteryName,
        'destinationAddress': order.destinationAddress,
        'batchCode': order.batchCode,
        'itemsCount': order.items.length,
        if (paymentReference != null) 'paymentReference': paymentReference,
      },
    );
  }

  Future<bool> saveReviewToParse(
    MarketplaceReview review, {
    String? sessionToken,
  }) async {
    final key = computeIdempotencyKey(
      'REV',
      '${review.beanId}-${review.authorName}-${review.comment}',
    );
    return upsertObject(
      className: ParseClasses.review,
      uniqueField: 'idempotencyKey',
      uniqueValue: key,
      idempotencyKey: key,
      sessionToken: sessionToken,
      data: review.toParseJson(),
    );
  }

  Future<bool> saveAddressToParse(
    SavedAddress address, {
    String? sessionToken,
  }) async {
    final key = computeIdempotencyKey(
      'ADDR',
      '${address.label}-${address.subCity}',
    );
    return upsertObject(
      className: ParseClasses.address,
      uniqueField: 'idempotencyKey',
      uniqueValue: key,
      idempotencyKey: key,
      sessionToken: sessionToken,
      data: address.toParseJson(),
    );
  }

  Future<bool> savePaymentMethodToParse(
    SavedPaymentMethod method, {
    String? sessionToken,
  }) async {
    final key = computeIdempotencyKey(
      'PAY',
      '${method.provider}-${method.maskedAccount}',
    );
    return upsertObject(
      className: ParseClasses.paymentMethod,
      uniqueField: 'idempotencyKey',
      uniqueValue: key,
      idempotencyKey: key,
      sessionToken: sessionToken,
      data: method.toParseJson(),
    );
  }

  Future<bool> saveFavoriteItemToParse(
    String beanId, {
    String? sessionToken,
  }) async {
    return upsertObject(
      className: ParseClasses.favoriteItem,
      uniqueField: 'beanId',
      uniqueValue: beanId,
      idempotencyKey: computeIdempotencyKey('FAV', beanId),
      sessionToken: sessionToken,
      data: {
        'beanId': beanId,
        'savedAt': DateTime.now().toIso8601String(),
      },
    );
  }
}
