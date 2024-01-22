
import 'package:shoppinglist_app/data/categories.dart';
import 'package:shoppinglist_app/model/category.dart';
import '../model/grocery_model.dart';

final groceryItems = [

  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];