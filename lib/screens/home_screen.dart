import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/data/categories.dart';
import 'package:shoppinglist_app/model/category.dart';
import 'package:shoppinglist_app/model/grocery_model.dart';
import 'package:shoppinglist_app/provider/grocery_provider.dart';
import 'package:shoppinglist_app/screens/add_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var groceryList = ref.watch(groceryProvider);
    void getData() async {
      final url = Uri.https('shopping-list-cdaad-default-rtdb.firebaseio.com',
          'shopping_list.json');
      final response = await http.get(url);
      final Map data = json.decode(response.body);
      final List<GroceryItem> loadedList = [];

      for (final item in data.entries) {
        final Category category = categories.entries
            .firstWhere((element) =>
                element.value.categoryType == item.value['category'])
            .value;
        loadedList.add(GroceryItem(
          id: item.value['id'],
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ));
      }
      ref.read(groceryProvider.notifier).update(loadedList);
    }

    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            getData();
          },
          child: const Text("Get Data"),
        ),
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: groceryList.isEmpty
            ? const Center(
                child: Text("No meal Available!"),
              )
            : ListView.builder(
                itemCount: groceryList.length,
                itemBuilder: (context, index) {
                  var grocery = groceryList[index];
                  return Dismissible(
                    key: ValueKey(grocery.id),
                    onDismissed: (direction) {
                      ref.read(groceryProvider.notifier).remove(grocery);
                    },
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: grocery.category.categoryColor,
                        ),
                        width: 25,
                        height: 25,
                      ),
                      title: Text(grocery.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      trailing: Text(
                        grocery.quantity.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  );
                },
              ));
  }
}
