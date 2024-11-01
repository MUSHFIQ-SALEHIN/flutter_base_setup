import 'package:flutter/material.dart';
import 'package:flutter_base_setup/features/item_list/providers/providers.dart';
import 'package:flutter_base_setup/features/item_list/widgets/theme_button.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/app_router.dart';

class ItemListScreen extends ConsumerStatefulWidget {
  const ItemListScreen({super.key});

  @override
  ItemListScreenState createState() => ItemListScreenState();
}

class ItemListScreenState extends ConsumerState<ItemListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false; // Track if more items are loading

  @override
  void initState() {
    super.initState();
    initialization();
    _scrollController.addListener(_onScroll);
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  void _onScroll() {
    // Trigger loading more items when scrolled near the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Check if more items should be loaded
      if (!_isLoadingMore) {
        _loadMoreItems();
      }
    }
  }

  Future<void> _loadMoreItems() async {
    _isLoadingMore = true; // Set loading state
    // Trigger loading more items through the notifier
    await ref.read(itemListProvider.notifier).loadMoreItems();
    _isLoadingMore = false; // Reset loading state after fetching
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
              hintText: 'Search git repositories...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
              fillColor: Colors.white),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            // Update the search query when the user submits
            ref.read(itemListProvider.notifier).updateSearchQuery(value);
          },
        ),
        actions: const [
          ThemeToggleButton()
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final itemsAsyncValue = ref.watch(itemListProvider);

          return itemsAsyncValue.when(
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (error, stack) {
              return Center(child: Text('Error: ${error.toString()}'));
            },
            data: (items) {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    // Trigger load more when reaching the bottom
                    if (!_isLoadingMore) {
                      _loadMoreItems();
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: items.length + (_isLoadingMore ? 1 : 0), // Add loading indicator
                  itemBuilder: (context, index) {
                    if (index == items.length && _isLoadingMore) {
                      // Show loading indicator at the bottom
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name!),
                      subtitle: Text(item.owner!.starredUrl!),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.itemDetails,
                          arguments: item,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
