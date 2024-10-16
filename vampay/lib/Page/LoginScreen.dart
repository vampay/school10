import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampay/controller/authController.dart';
import 'package:vampay/models/auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vampay/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedRole = 'user'; // Default to 'user'

  void _login() async {
    if (_formKey.currentState!.validate() && _selectedRole.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserModel userModel = await AuthController()
            .login(context, _emailController.text, _passwordController.text);

        if (!mounted) return;

        Provider.of<UserProvider>(context, listen: false).onLogin(userModel);

        // Provide feedback to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );

        Navigator.pushReplacementNamed(
            context, _selectedRole == 'admin' ? '/homeadmin' : '/home');
      } catch (e) {
        debugPrint('Login error: $e'); // Log error for debugging
        _showErrorDialog(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showErrorDialog('Please select a role');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: SvgPicture.asset(
              'images/top.svg',
              width: 400,
              height: 250,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: [
                        DropdownMenuItem(
                          value: 'admin',
                          child: Text('Admin'),
                        ),
                        DropdownMenuItem(
                          value: 'user',
                          child: Text('User'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select Role',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Already have an Account? Signup',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
