import 'dart:convert';

class RequirementCategory {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  RequirementCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RequirementCategory.fromJson(Map<String, dynamic> json) =>
      RequirementCategory(
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

List<RequirementCategory> requirementCategoriesFromJson(String str) =>
    List<RequirementCategory>.from(
      json.decode(str)["data"].map((x) => RequirementCategory.fromJson(x)),
    );
