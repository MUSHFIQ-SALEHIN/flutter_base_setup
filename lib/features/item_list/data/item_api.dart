import 'package:dio/dio.dart';
import 'package:flutter_base_setup/core/constants/urls.dart';
import '../domain/item_model.dart';

class ItemApi {
  final Dio dio;

  ItemApi(this.dio);

  Future<List<ItemModel>> fetchItems() async {
    final response = await dio.get(ApiEndpoints.items);
    return (response.data as List).map((e) => ItemModel.fromJson(e)).toList();
  }
}
