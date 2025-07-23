import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  // IDs aller monatlichen Abos wie im Store definiert
  static const List<String> _productIds = [
    'atyourservice_gold',
    'atyourservice_silver',
  ];

  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  Future<ProductDetailsResponse> getProducts() async {
    return await _inAppPurchase.queryProductDetails(_productIds.toSet());
  }

  Stream<List<PurchaseDetails>> listenToPurchases() {
    return _inAppPurchase.purchaseStream;
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  Future<bool> isAvailable() async {
    return await _inAppPurchase.isAvailable();
  }
}
