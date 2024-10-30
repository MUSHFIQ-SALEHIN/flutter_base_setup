class ItemModel {
  final int id;
  final String name;
  final String description;

  ItemModel({required this.id, required this.name, required this.description});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['title'],
      description: json['body'],
    );
  }
}
