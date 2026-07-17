/// Mirrors the backend's UserDto: { id, name, email, phone, role }
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        role: json['role'] as String,
      );
}
