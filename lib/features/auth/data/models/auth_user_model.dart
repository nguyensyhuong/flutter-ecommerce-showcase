import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: (json['username'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      gender: (json['gender'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
    );
  }
}
