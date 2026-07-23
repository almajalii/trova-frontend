/// Mirrors the backend's UserDto: { id, name, email, phone, role,
/// approvalStatus, rejectionReason }
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;

  /// "pending" | "approved" | "rejected". Accounts start "pending" and most
  /// endpoints 403 until an admin approves them.
  final String approvalStatus;
  final String? rejectionReason;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.approvalStatus,
    this.rejectionReason,
  });

  bool get isApproved => approvalStatus == 'approved';
  bool get isPending => approvalStatus == 'pending';
  bool get isRejected => approvalStatus == 'rejected';

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        role: json['role'] as String,
        // Falls back to "approved" so endpoints/environments that haven't
        // rolled out the approval gate yet keep behaving as before.
        approvalStatus: json['approvalStatus'] as String? ?? 'approved',
        rejectionReason: json['rejectionReason'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'approvalStatus': approvalStatus,
        'rejectionReason': rejectionReason,
      };
}
