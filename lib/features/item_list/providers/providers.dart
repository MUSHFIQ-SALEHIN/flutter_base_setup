import 'package:flutter_base_setup/core/network/api_client.dart';
import 'package:flutter_base_setup/features/item_list/data/item_api.dart';
import 'package:flutter_base_setup/features/item_list/data/item_repository.dart';
import 'package:flutter_base_setup/features/item_list/domain/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');
final itemsPerPageProvider = StateProvider<int>((ref) => 15);
// Provider to fetch items based on search query
final filteredItemsProvider =
    FutureProvider.family<List<Items>, String>((ref, searchQuery) {
  final apiClient = ref.watch(apiClientProvider);
  final itemsPerPage = ref.watch(itemsPerPageProvider);
  final itemApi = ItemApi(apiClient.dio);
  final repository = ItemRepository(itemApi);
  return searchQuery.isEmpty
      ? Future.value([]) // Return an empty list if no search query
      : repository.fetchItems(
          searchQuery: searchQuery, itemsPerPage: itemsPerPage);
});

// Create a provider for the ItemListNotifier
final itemListProvider =
    StateNotifierProvider<ItemListNotifier, AsyncValue<List<Items>>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final itemApi = ItemApi(apiClient.dio);
  final repository = ItemRepository(itemApi);
  final search = ref.watch(searchQueryProvider);
  final items = ref.watch(itemsPerPageProvider);
  return ItemListNotifier(repository, items, search);
});

class ItemListNotifier extends StateNotifier<AsyncValue<List<Items>>> {
  ItemListNotifier(this._repository, this._itemsPerPage, this._searchQuery)
      : super(const AsyncValue.loading()) {
    _fetchItems();
  }

  final ItemRepository _repository;
  int _itemsPerPage; // Initial number of items to fetch
  String _searchQuery;

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
    _searchQuery = query;
    _itemsPerPage = 15; // Reset items per page on new search
    _fetchItems();
  }

  Future<void> loadMoreItems() async {
    _itemsPerPage += 10; // Increase items per page
    await _fetchItems();
  }
}
