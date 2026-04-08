import '../../auth/model/user_model.dart';

class UserMgmtModel {
  final UserModel user;
  final String district;
  final String status;
  final String lastLogin;

  const UserMgmtModel({
    required this.user,
    required this.district,
    required this.status,
    required this.lastLogin,
  });

  UserMgmtModel copyWith({
    UserModel? user,
    String? district,
    String? status,
    String? lastLogin,
  }) {
    return UserMgmtModel(
      user: user ?? this.user,
      district: district ?? this.district,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
