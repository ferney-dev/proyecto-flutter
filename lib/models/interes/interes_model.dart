class Interes {
  final int id;
  final String name;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  Interes({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Interes.fromJson(Map<String, dynamic> json) {
    return Interes(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
      };
}
