// lib/modules/home/models/item_model.dart

class ItemModel {
  final double value;
  final String createdAt;

  ItemModel({
    required this.value,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      value: (json['value'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'createdAt': createdAt,
      };

  static List<ItemModel> fromList(List data) {
    return data.map((e) => ItemModel.fromJson(e)).toList();
  }
}
