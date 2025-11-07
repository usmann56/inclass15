import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firestore_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;
  const AddEditItemScreen({Key? key, this.item}) : super(key: key);

  @override
  _AddEditItemScreenState createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  bool get isEditMode => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _quantityController = TextEditingController(
      text: widget.item?.quantity.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.item?.price.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.item?.category ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final item = Item(
        id: widget.item?.id,
        name: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        price: double.parse(_priceController.text.trim()),
        category: _categoryController.text.trim(),
        createdAt: widget.item?.createdAt ?? DateTime.now(),
      );

      try {
        if (isEditMode) {
          await _firestoreService.updateItem(item);
        } else {
          await _firestoreService.addItem(item);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving item: $e')));
      }
    }
  }

  Future<void> _deleteItem() async {
    if (widget.item == null || widget.item!.id == null) return;
    try {
      await _firestoreService.deleteItem(widget.item!.id!);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting item: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Item' : 'Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Quantity must be a whole number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Price must be a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter category' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveItem,
                icon: const Icon(Icons.save),
                label: Text(isEditMode ? 'Update Item' : 'Add Item'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (isEditMode) ...[
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _deleteItem,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
