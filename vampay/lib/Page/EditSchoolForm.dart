import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:vampay/varibles.dart';

class EditSchoolForm extends StatefulWidget {
  final dynamic schoolData;

  EditSchoolForm({required this.schoolData});

  @override
  _EditSchoolFormState createState() => _EditSchoolFormState();
}

class _EditSchoolFormState extends State<EditSchoolForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolNameController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _locationController;
  late TextEditingController _studentCountController;
  late TextEditingController _teacherNameController;
  late TextEditingController _phoneTeacherController;
  late TextEditingController _facultyController;
  late TextEditingController _countParticipantsController;

  @override
  void initState() {
    super.initState();
    _schoolNameController = TextEditingController(text: widget.schoolData['school_name']);
    _dateController = TextEditingController(text: widget.schoolData['date']);
    _startTimeController = TextEditingController(text: widget.schoolData['startTime']);
    _endTimeController = TextEditingController(text: widget.schoolData['endTime']);
    _locationController = TextEditingController(text: widget.schoolData['location']);
    _studentCountController = TextEditingController(text: widget.schoolData['student_count'].toString());
    _teacherNameController = TextEditingController(text: widget.schoolData['teacher_name']);
    _phoneTeacherController = TextEditingController(text: widget.schoolData['phone_teacher']);
    _facultyController = TextEditingController(text: widget.schoolData['faculty']);
    _countParticipantsController = TextEditingController(text: widget.schoolData['count_participants'].toString());
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('$apiURL/api/school/${widget.schoolData['_id']}'),
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
        SnackBar(content: Text(response.statusCode == 200 ? 'Data updated successfully!' : 'Failed to update data.')),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Navigate back to the previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit School Activity'),
        backgroundColor: Colors.white, // Set AppBar color to white
        foregroundColor: Colors.black, // Set text color to black for visibility
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_schoolNameController, 'โรงเรียน', false),
                _buildDatePickerField(_dateController, 'วันที่ (YYYY-MM-DD)'),
                _buildTimePickerField(_startTimeController, 'เวลาเริ่มกิจกรรม'),
                _buildTimePickerField(_endTimeController, 'เวลากิจกรรมสิ้นสุด'),
                _buildTextField(_locationController, 'สถานที่', false),
                _buildTextField(_studentCountController, 'จำนวนนักเรียนที่เข้าร่วม', true),
                _buildTextField(_teacherNameController, 'ชื่อครูที่ติดต่อ', false),
                _buildTextField(_phoneTeacherController, 'เบอร์โทรที่ติดต่อ', false),
                _buildTextField(_facultyController, 'ผู้ประสานงาน', false),
                _buildTextField(_countParticipantsController, 'จำนวนผู้เข้าร่วม', true),
                SizedBox(height: 20),
                Center( // Center the button
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text('Update', style: TextStyle(color: Colors.white)), // Change text color to white
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
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
          ),
          filled: true,
          fillColor: Colors.blue[100],
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
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(controller, label, false),
      ),
    );
  }

  Widget _buildTimePickerField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          controller.text = pickedTime.format(context);
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(controller, label, false),
      ),
    );
  }
}