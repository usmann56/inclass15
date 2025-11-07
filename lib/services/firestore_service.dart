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

class FirestoreService {
  final CollectionReference _itemsCollection = FirebaseFirestore.instance
      .collection('Item');

  Future<void> addItem(Item item) async {
    try {
      await _itemsCollection.add(item.toMap());
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  Stream<List<Item>> getItemsStream() {
    return _itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Item.fromDocument(doc)).toList();
    });
  }

  Future<void> updateItem(Item item) async {
    if (item.id == null) {
      throw ArgumentError('Item ID cannot be null for update');
    }

    try {
      await _itemsCollection.doc(item.id).update(item.toMap());
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _itemsCollection.doc(itemId).delete();
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }
}
