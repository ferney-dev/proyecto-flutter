class InstitutionModel {
  final int id;
  final String name;
  final String website;

  InstitutionModel({
    required this.id,
    required this.name,
    required this.website,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'website': website,
    };
  }

  static const String apiUrl = "http://localhost:4000/api/v1/institutions";
}
