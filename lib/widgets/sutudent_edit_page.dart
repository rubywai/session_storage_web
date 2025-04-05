import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lessoon_storage/models/student_model.dart';
import 'package:lessoon_storage/notifiers/student_database_notifier.dart';
import 'package:provider/provider.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({
    super.key,
    required this.studentModel,
  });
  final StudentModel studentModel;
  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Uint8List? _photo;
  @override
  void initState() {
    super.initState();
    StudentModel studentModel = widget.studentModel;
    _nameController.text = studentModel.name ?? "";
    _ageController.text = studentModel.age?.toString() ?? "";
    _addressController.text = studentModel.address ?? "";
    _majorController.text = studentModel.major ?? "";
    _phoneController.text = studentModel.phone ?? "";
    _photo = studentModel.photo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          readOnly: true,
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Enter student name',
          ),
        ),
        TextField(
          readOnly: true,
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
          readOnly: true,
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
                      .updateStudent(
                    id: widget.studentModel.id!,
                    address: address,
                    phone: phone,
                    photo: _photo,
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
          child: Text('Update'),
        )
      ],
    );
  }
}
