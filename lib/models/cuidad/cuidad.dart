import 'dart:convert';

// 🔹 Modelo principal City
class City {
  final int id;
  final String name;
  final int departmentId;
  final String createdAt;
  final String updatedAt;
  final Department? department;

  City({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
    this.department,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        departmentId: json["departmentId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        department:
            json["department"] != null ? Department.fromJson(json["department"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "departmentId": departmentId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "department": department?.toJson(),
      };
}

// 🔹 Submodelo Department (anidado en City)
class Department {
  final int id;
  final String name;

  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// 🔹 Parser auxiliar
List<City> citiesFromJson(String str) =>
    List<City>.from(json.decode(str)["data"].map((x) => City.fromJson(x)));
