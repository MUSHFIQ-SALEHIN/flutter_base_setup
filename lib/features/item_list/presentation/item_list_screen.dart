import 'package:flutter/material.dart';
import 'package:flutter_base_setup/features/item_list/widgets/theme_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/item_repository.dart';
import '../../../core/routing/app_router.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  ItemListScreenState createState() => ItemListScreenState();
}

class ItemListScreenState extends State<ItemListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final itemsAsyncValue = ref.watch(itemsProvider);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Items'),
            actions: const [ThemeToggleButton()],
          ),
          body: itemsAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Center(child: Text('Error loading items')),
            data: (items) {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.itemDetails,
                        arguments: item,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
