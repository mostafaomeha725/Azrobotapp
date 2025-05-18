class SignInModel {
  final String message;
  final String token;
  final bool isVerified;
  final int userId; // Add user ID field

  SignInModel({
    required this.message,
    required this.token,
    required this.isVerified,
    required this.userId, // Add to constructor
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};

    return SignInModel(
      message: data['message'] ?? "Login successful",
      token: data['token'] ?? "",
      isVerified: user['is_verified'] ?? false,
      userId: data ['user']['id'] ?? 0, // Parse user ID from response
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "is_verified": isVerified,
        "user_id": userId, // Include in serialization
      };
}