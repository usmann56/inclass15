import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  // TODO: Declare fields (id, name, quantity, price, category, createdAt)
  // TODO: Create constructor with named parameters
  // TODO: Implement toMap() for Firestore
  final int id = 0;
  final String name = '';
  final int quantity = 0;
  final double price = 0.0;
  final String category = '';
  final DateTime createdAt = DateTime.now();
  Map<String, dynamic> toMap() {
    return {
      // TODO: Convert all fields to map
    };
  }

  // TODO: Implement fromMap() factory constructor
  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      // TODO: Extract values from map
      // id: id,
      // name: map['name'],
      // quantity: map['quantity'],
      // price: map['price'],
      // category: map['category'],
      // createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

class FirestoreService {
  // TODO: Create collection reference for 'items'
  // TODO: Implement addItem method
  Future<void> addItem(Item item) async {
    // TODO: Convert item to map and add to collection
  }
  // TODO: Implement getItemsStream method
  Stream<List<Item>> getItemsStream() {
    // TODO: Return stream of items from Firestore
  }
  // TODO: Implement updateItem method
  Future<void> updateItem(Item item) async {
    // TODO: Update specific document by ID
  }
  // TODO: Implement deleteItem method
  Future<void> deleteItem(String itemId) async {
    // TODO: Delete document by ID
  }
}
