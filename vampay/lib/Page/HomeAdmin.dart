import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:vampay/Page/EditSchoolForm.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:vampay/varibles.dart'; // Ensure the path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Card Display',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Blue primary swatch for the theme
        scaffoldBackgroundColor: Colors.blue[50], // Light blue background for the app
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // White text for elevated buttons
            backgroundColor: Colors.blue, // Blue background for elevated buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners for buttons
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: ApiCardPage(),
      routes: {
        '/add_school': (context) => AddSchoolPage(), // Define the route for the add school page
      },
    );
  }
}

class ApiCardPage extends StatefulWidget {
  @override
  _ApiCardPageState createState() => _ApiCardPageState();
}

class _ApiCardPageState extends State<ApiCardPage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('$apiURL/api/school/'));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'School Activities',
          style: TextStyle(color: Colors.white), // Set AppBar title color to white
        ),
        backgroundColor: Colors.blue, // Set the AppBar background color here
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Add School') {
                // Navigate to the new page to add school
                Navigator.pushNamed(context, '/add_school').then((_) {
                  // Refresh the data when returning to this page
                  fetchData();
                });
              } else if (choice == 'Logout') {
                // Handle logout action
                _logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Add School', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice, style: TextStyle(color: Colors.black)), // Set PopupMenu text color
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.blue)) // Blue spinner
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners for cards
                  ),
                  color: Colors.blue[50], // Light blue background for the cards
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['school_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue[900]), // Dark blue text
                        ),
                        SizedBox(height: 5),
                        Text(
                          'วันที่: ${DateTime.parse(item['date']).toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ช่วงเวลา: ${item['startTime']} - ${item['endTime']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'สถานที่: ${item['location']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'จำนวนนักเรียนที่เข้าร่วม: ${item['student_count']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ชื่อครูที่ติดต่อ: ${item['teacher_name']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'เบอร์โทรที่ติดต่อ: ${item['phone_teacher']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ผู้ประสานงาน: ${item['faculty']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'จำนวนผู้เข้าร่วม: ${item['count_participants']}',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                deleteRow(item['_id']);
                              },
                              child: Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Red for delete button
                                foregroundColor: Colors.white, // White text color
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSchoolForm(schoolData: item),
                                  ),
                                );
                              },
                              child: Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700], // Blue for edit button
                                foregroundColor: Colors.white, // White text color
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _logout() {
    // Clear any stored user data if applicable
    // For example, if you are using Shared Preferences:
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    // Navigate to the login page
    Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
  }

  void deleteRow(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete', style: TextStyle(color: Colors.blue[900])),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await http.delete(Uri.parse('$apiURL/api/school/$id'));
              if (response.statusCode == 200) {
                setState(() {
                  _data.removeWhere((element) => element['_id'] == id);
                });
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item deleted successfully')),
                );
                // After deletion, refresh the data
                fetchData();
              } else {
                Navigator.of(context).pop(); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete item')),
                );
              }
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }
}

// AddSchoolPage Widget to be created here as a placeholder for the actual add page
class AddSchoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New School', style: TextStyle(color: Colors.white)), // Set title color to white
      ),
      body: Center(
        child: Text('Form to add a new school will go here'),
      ),
    );
  }
}