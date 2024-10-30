import 'package:flutter/material.dart';
import 'package:flutter_base_setup/features/item_list/domain/item_model.dart';
import 'package:flutter_base_setup/features/item_list/presentation/item_details_screen.dart';
import 'package:flutter_base_setup/features/item_list/presentation/item_list_screen.dart';

class AppRouter {
  static const String itemList = '/';
  static const String itemDetails = '/item-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case itemList:
        return MaterialPageRoute(builder: (_) => ItemListScreen());

      case itemDetails:
        final item = settings.arguments as ItemModel;
        return MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
