import 'dart:convert';

class RequirementCheck {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  RequirementCheck({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RequirementCheck.fromJson(Map<String, dynamic> json) => RequirementCheck(
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

// 🔹 Convertir JSON de la API en lista
List<RequirementCheck> requirementChecksFromJson(String str) =>
    List<RequirementCheck>.from(
      json.decode(str)["data"].map((x) => RequirementCheck.fromJson(x)),
    );
