import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ProviderModel with ChangeNotifier {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool available = true;
  StreamSubscription subscription;
  final String myProductID = "upgrade_pro";

  bool _ispurchased = false;
  bool get isPurchased => _ispurchased;
  set isPurchased(bool value) {
    _ispurchased = value;
    notifyListeners();
  }

  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }

  List _products = [];
  List get products => _products;
  set products(List value) {
    _products = value;
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      await _getPastPurchases();
      verifyPurchases();
      subscription = _iap.purchaseUpdatedStream.listen((data) {
        purchases.addAll(data);
        verifyPurchases();
      });
    }
  }

  void verifyPurchases() {
    PurchaseDetails purchase = hasPurchased(myProductID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        isPurchased = true;
      }
    }
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([myProductID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.consumePurchase(purchase);
      }
    }
    purchases = response.pastPurchases;
  }
}
