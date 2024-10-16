import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vampay/varibles.dart'; // Ensure this imports your variables correctly

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedRole = 'User'; // Default role
  final List<String> _roles = ['Admin', 'User'];

  Future<void> register() async {
    final response = await http.post(
      Uri.parse('$apiURL/api/auth/register'), // Replace with your API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'role': _selectedRole,
        'email': _emailController.text,
      }),
    );

    // Log the response status and body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      // Optionally, navigate to the login page or home page
      Navigator.pushNamed(context, '/login');
    } else {
      // Show detailed error message if available
      String errorMessage = 'Registration failed! Please try again.';
      try {
        var errorResponse = jsonDecode(response.body);
        errorMessage = errorResponse['message'] ?? errorMessage;
      } catch (e) {
        print('Error parsing error response: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Signup',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Signup',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login'); // Navigate to login page
              },
              child: Text(
                'Already have an Account? Sign in',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
