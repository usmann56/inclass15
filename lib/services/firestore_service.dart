import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final DateTime createdAt;

  Item({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map, {String? id}) {
    return Item(
      id: id,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] ?? 0.0),
      category: map['category'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  factory Item.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item.fromMap(data, id: doc.id);
  }
}

// class FirestoreService {
//   // TODO: Create collection reference for 'items'
//   // TODO: Implement addItem method
//   Future<void> addItem(Item item) async {
//     // TODO: Convert item to map and add to collection
//   }
//   // TODO: Implement getItemsStream method
//   Stream<List<Item>> getItemsStream() {
//     // TODO: Return stream of items from Firestore
//   }
//   // TODO: Implement updateItem method
//   Future<void> updateItem(Item item) async {
//     // TODO: Update specific document by ID
//   }
//   // TODO: Implement deleteItem method
//   Future<void> deleteItem(String itemId) async {
//     // TODO: Delete document by ID
//   }
// }
