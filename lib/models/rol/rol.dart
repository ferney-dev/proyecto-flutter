class Rol {
  final int id;
  final String name;

  Rol({required this.id, required this.name});

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }
}
