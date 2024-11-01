import '../domain/item_model.dart';
import 'item_api.dart';

class ItemRepository {
  final ItemApi api;

  ItemRepository(this.api);

  Future<List<Items>> fetchItems({required String searchQuery,required int itemsPerPage}) => api.fetchItems(searchQuery: searchQuery,itemsPerPage:itemsPerPage);

  
}


