import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  InAppPurchaseService._internal();
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  // iOS: exakt wie in App Store Connect
  static const List<String> _iosIds = [
    'atyourservice_gold_v2',
    'atyourservice_silver_v2',
  ];

  // Android (falls andere IDs – hier deine bisherigen)
  static const List<String> _androidIds = [
    'atyourservice_gold',
    'atyourservice_silver',
  ];

  Set<String> _idsForPlatform() =>
      (Platform.isIOS ? _iosIds : _androidIds).toSet();

  Future<ProductDetailsResponse> getProducts() async {
    final resp = await _inAppPurchase.queryProductDetails(_idsForPlatform());
    return resp;
  }

  Stream<List<PurchaseDetails>> listenToPurchases() {
    return _inAppPurchase.purchaseStream;
  }

  Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  Future<bool> isAvailable() async {
    return _inAppPurchase.isAvailable();
  }
}
