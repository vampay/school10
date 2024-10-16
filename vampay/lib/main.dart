import 'package:flutter/material.dart';
import 'package:vampay/Page/EditSchoolForm.dart';
import 'package:vampay/Page/HomeAdmin.dart';
import 'package:vampay/Page/LoginScreen.dart';  
import 'package:vampay/Page/SchoolForm.dart';
import 'package:vampay/Page/register_page.dart';
import 'package:vampay/providers/user_provider.dart';
import 'package:vampay/varibles.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Login Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterPage(),
          '/homeadmin': (context) => ApiCardPage(),
          '/add_school': (context) => SchoolForm(),
          '/EditSchoolForm': (context) => EditSchoolForm(schoolData: null),
        },
      ),
    );
  }
}

