import 'package:flutter_base_setup/core/network/api_client.dart';
import 'package:flutter_base_setup/features/item_list/data/item_api.dart';
import 'package:flutter_base_setup/features/item_list/data/item_repository.dart';
import 'package:flutter_base_setup/features/item_list/domain/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for the ItemListNotifier
final itemListProvider =
    StateNotifierProvider<ItemListNotifier, AsyncValue<List<Items>>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final itemApi = ItemApi(apiClient.dio);
  final repository = ItemRepository(itemApi);
  return ItemListNotifier(repository);
});

class ItemListNotifier extends StateNotifier<AsyncValue<List<Items>>> {
  ItemListNotifier(this._repository) : super(const AsyncValue.loading()) {
    _fetchItems();
  }

  final ItemRepository _repository;
  int _itemsPerPage = 10; // Initial number of items to fetch
  String _searchQuery = '';

  Future<void> _fetchItems() async {
    if (_searchQuery.isNotEmpty) {
      try {
        final items = await _repository.fetchItems(
            searchQuery: _searchQuery, itemsPerPage: _itemsPerPage);
        state = AsyncValue.data(items);
      } catch (e) {
        state = const AsyncValue.data([]);
      }
    } else {
      state = const AsyncValue.data([]);
    }
  }

  void updateSearchQuery(String query) {
     state = const AsyncValue.loading();
    _searchQuery = query;
    _itemsPerPage = 15; // Reset items per page on new search
    _fetchItems();
  }

  Future<void> loadMoreItems() async {
    _itemsPerPage += 10; // Increase items per page
    await _fetchItems();
  }
}
