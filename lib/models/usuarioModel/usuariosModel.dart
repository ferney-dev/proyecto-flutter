class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final bool isActive;
  final int? roleId;
  final String? imgUser;
  final String? roleName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.isActive,
    this.roleId,
    this.imgUser,
    this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"],
      isActive: json["is_active"] ?? true,
      roleId: json["role_id"],
      imgUser: json["imgUser"],
      roleName: json["role"]?["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "is_active": isActive,
      "role_id": roleId,
      "imgUser": imgUser,
    };
  }

  static const String apiUrl = "http://localhost:4000/api/v1/users";
}
