import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../domain/item_model.dart';
import 'item_api.dart';

final itemsProvider = FutureProvider<List<ItemModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final itemApi = ItemApi(apiClient.dio);
  final repository = ItemRepository(itemApi);
  return repository.fetchItems();
});

class ItemRepository {
  final ItemApi api;

  ItemRepository(this.api);

  Future<List<ItemModel>> fetchItems() => api.fetchItems();
}
