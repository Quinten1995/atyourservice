// lib/utils/in_app_purchase_service.dart
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  // Plattformwahl ohne dart:io (web-sicher)
  static bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  // 👉 IDs zentral + plattformspezifisch
  static String get silverId =>
      _isIOS ? 'atyourservice_silver_v2' : 'atyourservice_silver';
  static String get goldId =>
      _isIOS ? 'atyourservice_gold_v2' : 'atyourservice_gold';
  static Set<String> get _ids => {silverId, goldId};

  final InAppPurchase _iap = InAppPurchase.instance;

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<ProductDetailsResponse> getProducts() async {
    final resp = await _iap.queryProductDetails(_ids);
    if (kDebugMode) {
      debugPrint('IAP found: ${resp.productDetails.map((p) => p.id).toList()}');
      debugPrint('IAP notFound: ${resp.notFoundIDs}');
      if (resp.error != null) debugPrint('IAP error: ${resp.error}');
    }
    return resp;
  }

  Stream<List<PurchaseDetails>> listenToPurchases() => _iap.purchaseStream;

  Future<void> buyProduct(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param); // Subscriptions: ok
  }

  Future<void> restorePurchases() => _iap.restorePurchases();
}
