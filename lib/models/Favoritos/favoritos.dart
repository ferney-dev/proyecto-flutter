class FavoriteModel {
  final int id;
  final int userId;
  final int callId;
  final Map<String, dynamic>? call;
  final DateTime? favoritedAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.callId,
    this.call,
    this.favoritedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      callId: json['callId'] ?? 0,
      call: json['call'],
      favoritedAt: json['favoritedAt'] != null
          ? DateTime.tryParse(json['favoritedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'callId': callId,
      'call': call,
      'favoritedAt': favoritedAt?.toIso8601String(),
    };
  }
}
