import 'dart:convert';

class Requirement {
  final int id;
  final String name;
  final String notes;
  final int institutionId;
  final int groupId;
  final Map<String, dynamic>? institution;
  final Map<String, dynamic>? requirementGroup;
  final String createdAt;
  final String updatedAt;

  Requirement({
    required this.id,
    required this.name,
    required this.notes,
    required this.institutionId,
    required this.groupId,
    this.institution,
    this.requirementGroup,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) => Requirement(
        id: json["id"],
        name: json["name"],
        notes: json["notes"],
        institutionId: json["institutionId"],
        groupId: json["groupId"],
        institution: json["institution"],
        requirementGroup: json["requirementGroup"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );
}

List<Requirement> requirementsFromJson(String str) =>
    List<Requirement>.from(json.decode(str)["data"].map((x) => Requirement.fromJson(x)));
