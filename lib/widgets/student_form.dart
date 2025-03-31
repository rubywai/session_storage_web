import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/student_model.dart';
import '../notifiers/student_database_notifier.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Uint8List? _photo;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Enter student name',
          ),
        ),
        TextField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter student age',
          ),
        ),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Enter student address',
          ),
        ),
        TextField(
          controller: _majorController,
          decoration: InputDecoration(
            labelText: 'Enter student major',
          ),
        ),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Enter student phone',
          ),
        ),
        TextButton(
          onPressed: () async {
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);
            if (file != null) {
              File imageFile = File(file.path);
              Uint8List imageBinary = imageFile.readAsBytesSync();
              setState(() {
                _photo = imageBinary;
              });
            }
          },
          child: Text("Select Image"),
        ),
        if (_photo != null)
          SizedBox(
            width: 100,
            height: 100,
            child: Image.memory(_photo!),
          ),
        FilledButton(
          onPressed: () async {
            String name = _nameController.text.trim();
            String age = _ageController.text.trim();
            String address = _addressController.text.trim();
            String major = _majorController.text.trim();
            String phone = _phoneController.text.trim();
            if (name.isNotEmpty &&
                age.isNotEmpty &&
                address.isNotEmpty &&
                major.isNotEmpty &&
                phone.isNotEmpty) {
              int? formattedAge = int.tryParse(age);
              if (formattedAge == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("please enter age correctly"),
                  ),
                );
              } else {
                try {
                  Provider.of<StudentDatabaseNotifier>(context, listen: false)
                      .insertStudent(
                    StudentModel(
                      name: name,
                      age: formattedAge,
                      address: address,
                      major: major,
                      phone: phone,
                      photo: _photo,
                    ),
                  );
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context, false);
                  }
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("please enter completely"),
                ),
              );
            }
          },
          child: Text('Save'),
        )
      ],
    );
  }
}
