class Linea {
  final int id;
  final String name;
  final String? description;

  Linea({required this.id, required this.name, this.description});

  factory Linea.fromJson(Map<String, dynamic> json) {
    return Linea(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
