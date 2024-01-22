import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/model/grocery_model.dart';

class GroceryProvider extends StateNotifier<List<GroceryItem>> {
  GroceryProvider() : super([]);

  void update(List<GroceryItem> newList) {
    state = newList;
  }

  void remove(selectedItem) {
    // state = state.where((element) => element.id != selectedItem.id).toList();
    // print('${selectedItem.name} deleted');
  }
}

final groceryProvider =
    StateNotifierProvider<GroceryProvider, List<GroceryItem>>(
        (ref) => GroceryProvider());
