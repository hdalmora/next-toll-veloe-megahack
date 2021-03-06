import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_toll_veloe/src/models/Item.dart';
import 'package:next_toll_veloe/src/models/ItemsList.dart';

class FirestoreResources {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> storeItemsList(String storeUID) => _firestore
      .collection("stores")
      .document(storeUID)
      .collection("items")
      .orderBy("timestamp", descending: true)
      .snapshots();

  Future<void> checkoutShoppingCartAndMakePurchase(String userUID, String storeUID, String storeName, String storeLogoUrl, List<Item> items, double totalValue, String paymentOption) {
    List<Map<String, dynamic>> itemsMap = new List<Map<String, dynamic>>();

    items.forEach((item) {
      itemsMap.add(item.toMap());
    });

    ItemsList itemsList = ItemsList(totalValue, storeUID, storeName, storeLogoUrl, paymentOption, itemsMap, FieldValue.serverTimestamp());

    return _firestore
        .collection("userClient")
        .document(userUID)
        .collection("purchases")
        .document()
        .setData(itemsList.toMap());
  }

  Stream<QuerySnapshot> purchasesList(String userUID) => _firestore
      .collection("userClient")
      .document(userUID)
      .collection("purchases")
      .orderBy('timestamp', descending: true)
      .snapshots();

  Stream<QuerySnapshot> lastPurchase(String userUID) => _firestore
      .collection("userClient")
      .document(userUID)
      .collection("purchases")
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots();

  Future<DocumentSnapshot> storeDocument(String storeUID) => _firestore
      .collection("stores")
      .document(storeUID)
      .snapshots()
      .first;
}