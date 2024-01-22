import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/data/categories.dart';
import 'package:shoppinglist_app/model/category.dart';
import 'package:http/http.dart' as http;
import '../model/grocery_model.dart';

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({super.key});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  var _selectedCategory = Categories.carbs;
  void addItem(GroceryItem newItem) async {
    // state = [...state, newItem];

    //sending http request
    //making uri format request
    final url = Uri.https('shopping-list-cdaad-default-rtdb.firebaseio.com',
        'shopping_list.json');

    //waiting till we get response assuring storing of data
    final response = await http.post(
      url,
      headers: {'Type': 'Value(json)'},
      body: json.encode(
        {
          'id': newItem.id,
          'name': newItem.name,
          'quantity': newItem.quantity,
          'category': newItem.category.categoryType,
        },
      ),
    );
    print(response.body);
    print(response.statusCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String capitalize(String name) {
    var str1 = name.substring(0, 1).toUpperCase();
    var str2 = name.substring(1);
    return str1 + str2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Grocery Item Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Quantity",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<Categories>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: Categories.values.map((e) {
                        return DropdownMenuItem<Categories>(
                            value: e, child: Text(capitalize(e.name)));
                      }).toList(),
                      decoration: const InputDecoration(
                        hintText: "Category",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        addItem(
                          GroceryItem(
                            id: DateTime.now().toString(),
                            name: _nameController.text,
                            quantity:
                                int.tryParse(_quantityController.text) ?? 0,
                            category: categories[_selectedCategory]!,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add Item"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
