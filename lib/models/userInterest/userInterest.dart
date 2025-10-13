class UserInterest {
  final int userId;
  final int interestId;
  final String userName;
  final String interestName;
  final String? userImage;

  UserInterest({
    required this.userId,
    required this.interestId,
    required this.userName,
    required this.interestName,
    this.userImage,
  });

  factory UserInterest.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final interest = json['interest'] ?? {};

    return UserInterest(
      userId: json['userId'] ?? 0,
      interestId: json['interestId'] ?? 0,
      userName: user['name'] ?? 'Desconocido',
      interestName: interest['name'] ?? 'Sin interés',
      userImage: user['imgUser'],
    );
  }
}
