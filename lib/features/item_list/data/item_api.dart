import 'package:dio/dio.dart';
import 'package:flutter_base_setup/core/constants/urls.dart';
import '../domain/item_model.dart';

class ItemApi {
  final Dio dio;

  ItemApi(this.dio);

  Future<List<Items>> fetchItems({required String searchQuery,required int itemsPerPage}) async {
    final response = await dio.get(ApiEndpoints.posts,
        queryParameters: {"q": searchQuery, "sort": "stars","per_page":itemsPerPage});
    GitRepoModel model = GitRepoModel.fromJson(response.data);
    return model.items!;
  }
}
