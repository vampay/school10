import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vampay/varibles.dart';

class SchoolForm extends StatefulWidget {
  @override
  _SchoolFormState createState() => _SchoolFormState();
}

class _SchoolFormState extends State<SchoolForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _studentCountController = TextEditingController();
  final TextEditingController _teacherNameController = TextEditingController();
  final TextEditingController _phoneTeacherController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _countParticipantsController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  Future<void> _selectStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      _startTimeController.text = pickedTime.format(context);
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      _endTimeController.text = pickedTime.format(context);
    }
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('$apiURL/api/school/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'school_name': _schoolNameController.text,
          'date': _dateController.text,
          'startTime': _startTimeController.text,
          'endTime': _endTimeController.text,
          'location': _locationController.text,
          'student_count': int.parse(_studentCountController.text),
          'teacher_name': _teacherNameController.text,
          'phone_teacher': _phoneTeacherController.text,
          'faculty': _facultyController.text,
          'count_participants': int.parse(_countParticipantsController.text),
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.statusCode == 201 ? 'Data submitted successfully!' : 'Failed to submit data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Form', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildTextField(_schoolNameController, 'School Name', false),
                  _buildDatePickerField(_dateController, 'Date (YYYY-MM-DD)'),
                  _buildTimePickerField(_startTimeController, 'Start Time'),
                  _buildTimePickerField(_endTimeController, 'End Time'),
                  _buildTextField(_locationController, 'Location', false),
                  _buildTextField(_studentCountController, 'Student Count', true),
                  _buildTextField(_teacherNameController, 'Teacher Name', false),
                  _buildTextField(_phoneTeacherController, 'Teacher Phone', false),
                  _buildTextField(_facultyController, 'Faculty', false),
                  _buildTextField(_countParticipantsController, 'Count Participants', true),
                  SizedBox(height: 20),
                  Center( // Center the button
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue[200]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue[100],
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: _buildTextField(controller, label, false),
      ),
    );
  }

  Widget _buildTimePickerField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: label == 'Start Time' ? _selectStartTime : _selectEndTime,
      child: AbsorbPointer(
        child: _buildTextField(controller, label, false),
      ),
    );
  }
}