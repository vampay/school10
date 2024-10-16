import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vampay/providers/user_provider.dart';
import 'package:vampay/models/auth.dart';
import 'package:vampay/varibles.dart';

class AuthController {
  Future<UserModel> login(BuildContext context, String email, String password) async {
  final response = await http.post(
    Uri.parse("$apiURL/api/auth/login"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return UserModel.fromJson(data);
  } else {
    try {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception('Error: ${errorData['message']}');
    } catch (e) {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
}
