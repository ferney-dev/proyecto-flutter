class PublicoModel {
  final int id;
  final String name;

  PublicoModel({
    required this.id,
    required this.name,
  });

  factory PublicoModel.fromJson(Map<String, dynamic> json) {
    return PublicoModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name};
  }

  static const String apiUrl = "http://localhost:4000/api/v1/targetAudiences";
}
