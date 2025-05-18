class SignUpModel {
  final String message;
  final String token;
  final Map<String, dynamic>? data;

  SignUpModel({
    required this.message,
    required this.token,
    this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    try {
      return SignUpModel(
        message: json["message"]?.toString() ?? "Signup successful",
        token: json["token"]?.toString() ?? "",
        data: json["data"] is Map<String, dynamic> ? json["data"] : null,
      );
    } catch (e) {
      throw FormatException('Failed to parse SignUpModel: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        if (data != null) "data": data,
      };
}
