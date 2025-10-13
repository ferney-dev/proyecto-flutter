class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "is_active": true,
      "role_id": 1,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      password: json["password"] ?? "",
    );
  }

  // 🔹 Ruta de la API (centralizada en el modelo)
  static const String apiUrl = "http://localhost:4000/api/v1/users";
}
