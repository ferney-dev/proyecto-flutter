class Interes {
  final int id;
  final String name;

  Interes({required this.id, required this.name});

  factory Interes.fromJson(Map<String, dynamic> json) {
    return Interes(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
