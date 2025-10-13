import 'dart:convert';

class Department {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

List<Department> departmentsFromJson(String str) =>
    List<Department>.from(json.decode(str)["data"].map((x) => Department.fromJson(x)));
