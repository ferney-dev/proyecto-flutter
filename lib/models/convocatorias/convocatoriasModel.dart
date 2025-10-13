class Convocatoria {
  // ============================
  // 🔹 Campos base
  // ============================
  final int id;
  final String title;
  final String description;
  final String resources;
  final String callLink;
  final String openDate;
  final String closeDate;
  final String pageName;
  final String pageUrl;
  final String objective;
  final String notes;
  final String? imageUrl;

  // ============================
  // 🔹 IDs de relaciones
  // ============================
  final int? institutionId;
  final int? lineId;
  final int? targetAudienceId;
  final int? interestId;
  final int? userId;
  final int? clickCount;

  // ============================
  // 🔹 Datos relacionales (nombres y fotos)
  // ============================
  final String? lineaName;
  final String? interestName;
  final String? publicoObjetivoName;
  final String? institutionName;
  final String? userName;
  final String? userImage;

  // ============================
  // 🔹 Constructor
  // ============================
  Convocatoria({
    required this.id,
    required this.title,
    required this.description,
    required this.resources,
    required this.callLink,
    required this.openDate,
    required this.closeDate,
    required this.pageName,
    required this.pageUrl,
    required this.objective,
    required this.notes,
    this.imageUrl,
    this.institutionId,
    this.lineId,
    this.targetAudienceId,
    this.interestId,
    this.userId,
    this.clickCount,
    this.lineaName,
    this.interestName,
    this.publicoObjetivoName,
    this.institutionName,
    this.userName,
    this.userImage,
  });

  // ============================
  // 🔹 fromJson (lee datos anidados del backend)
  // ============================
  factory Convocatoria.fromJson(Map<String, dynamic> json) {
    // Relaciones anidadas (según estructura Sequelize)
    final linea = json['line'] ?? json['linea'] ?? {};
    final interes = json['interest'] ?? {};
    final publico = json['targetAudience'] ?? json['publicoObjetivo'] ?? {};
    final institucion = json['institution'] ?? {};
    final usuario = json['user'] ?? {};

    return Convocatoria(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      resources: json['resources'] ?? '',
      callLink: json['callLink'] ?? '',
      openDate: json['openDate'] ?? '',
      closeDate: json['closeDate'] ?? '',
      pageName: json['pageName'] ?? '',
      pageUrl: json['pageUrl'] ?? '',
      objective: json['objective'] ?? '',
      notes: json['notes'] ?? '',
      imageUrl: json['imageUrl'] ?? '',

      // IDs
      institutionId: json['institutionId'] ?? institucion['id'],
      lineId: json['lineId'] ?? linea['id'],
      targetAudienceId: json['targetAudienceId'] ?? publico['id'],
      interestId: json['interestId'] ?? interes['id'],
      userId: json['userId'] ?? usuario['id'],
      clickCount: json['clickCount'] ?? 0,

      // ✅ Nombres reales (si vienen anidados o planos)
      lineaName: linea['name'] ?? json['lineName'] ?? 'Sin línea registrada',
      interestName:
          interes['name'] ?? json['interestName'] ?? 'Sin interés registrado',
      publicoObjetivoName: publico['name'] ??
          json['targetAudienceName'] ??
          json['publicoObjetivoName'] ??
          'Sin público objetivo',
      institutionName: institucion['name'] ??
          json['institutionName'] ??
          'Institución no especificada',
      userName: usuario['name'] ?? json['userName'] ?? 'Usuario no asignado',
      userImage: usuario['imgUser'] ?? json['userImage'],
    );
  }

  // ============================
  // 🔹 toJson (para enviar al backend)
  // ============================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'resources': resources,
      'callLink': callLink,
      'openDate': openDate,
      'closeDate': closeDate,
      'pageName': pageName,
      'pageUrl': pageUrl,
      'objective': objective,
      'notes': notes,
      'imageUrl': imageUrl,
      'institutionId': institutionId,
      'lineId': lineId,
      'targetAudienceId': targetAudienceId,
      'interestId': interestId,
      'userId': userId,
      'clickCount': clickCount,
      'lineaName': lineaName,
      'interestName': interestName,
      'publicoObjetivoName': publicoObjetivoName,
      'institutionName': institutionName,
      'userName': userName,
      'userImage': userImage,
    };
  }

  // ============================
  // 🔹 Getters útiles
  // ============================
  String get imagenValida =>
      (imageUrl != null && imageUrl!.isNotEmpty)
          ? imageUrl!
          : "https://via.placeholder.com/400x200.png?text=Convocatoria";

  String get lineaValida => lineaName ?? "Sin línea registrada";
  String get interesValido => interestName ?? "Sin interés registrado";
  String get publicoValido => publicoObjetivoName ?? "Sin público objetivo";
  String get institucionValida => institutionName ?? "Sin institución";
  String get usuarioValido => userName ?? "Usuario no asignado";
}
