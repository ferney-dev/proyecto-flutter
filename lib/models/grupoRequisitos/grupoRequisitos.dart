import 'dart:convert';

class RequirementGroup {
  final int id;
  final String name;
  final int categoryId;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? category;
  final List<dynamic>? requirements;

  RequirementGroup({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.requirements,
  });

  factory RequirementGroup.fromJson(Map<String, dynamic> json) => RequirementGroup(
        id: json["id"],
        name: json["name"],
        categoryId: json["categoryId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        category: json["category"],
        requirements: json["requirements"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "categoryId": categoryId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

List<RequirementGroup> requirementGroupsFromJson(String str) =>
    List<RequirementGroup>.from(json.decode(str)["data"].map((x) => RequirementGroup.fromJson(x)));
