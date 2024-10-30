import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/item_repository.dart';
import '../../../core/routing/app_router.dart';

class ItemListScreen extends ConsumerWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsyncValue = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: itemsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Error loading items')),
        data: (items) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].name),
                subtitle: Text(items[index].description),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.itemDetails,
                    arguments: items[index],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
