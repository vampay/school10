class UserModel {
  User user;
  String accessToken;
  String refreshToken;

  UserModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"] ?? '',
        refreshToken: json["refreshToken"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class User {
  String email;
  String password;
  String name;
  String surname;
  String role;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        surname: json["surname"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "surname": surname,
        "role": role,
      };
}
