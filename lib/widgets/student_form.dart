import 'package:flutter/material.dart';
import 'package:lessoon_storage/storage/student_db.dart';

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
                  await StudentDatabase.insertStudent(
                    name: name,
                    age: formattedAge,
                    address: address,
                    major: major,
                    phone: phone,
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
