class EncarteModel {
  final String id;
  final String name;
  final String url;
  final bool isFavorite;
  final DateTime createdAt;

  EncarteModel({
    required this.id,
    required this.name,
    required this.url,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  EncarteModel copyWith({
    String? id,
    String? name,
    String? url,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return EncarteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EncarteModel.fromMap(Map<String, dynamic> map) {
    return EncarteModel(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      isFavorite: map['isFavorite'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
