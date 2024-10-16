class User {
  final String? id;
  final String? username;
  final String? name;
  final String? role;
  final String? email;

  User({this.id, this.username, this.name, this.role, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?, // Make nullable
      email: json['email'] as String?,
    );
  }
}

class UserModel {
  final String? userId;
  final User? user;
  final String? redirectUrl;

  UserModel({this.userId, this.user, this.redirectUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      redirectUrl: json['redirectUrl'] as String?,
    );
  }
}
