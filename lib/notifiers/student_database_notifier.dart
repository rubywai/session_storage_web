import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../storage/student_db.dart';

class StudentDatabaseNotifier extends ChangeNotifier {
  List<StudentModel> studentList = [];
  List<String> uniqueAddressList = [];
  String filter = "All";
  static Future<void> init() async {
    await StudentDatabase.createDatabase();
    await StudentDatabase.createStudentTable();
  }

  void getUniqueAddressList() async {
    final addressMap = await StudentDatabase.getUniqueAddressLit();
    uniqueAddressList = addressMap.map((e) {
      return e.values.first.toString();
    }).toList();
    notifyListeners();
  }

  void getAllStudents() async {
    studentList = await StudentDatabase.getAllStudents();
    filter = "All";
    notifyListeners();
  }

  void getAllStudentsByAddress(String address) async {
    studentList = await StudentDatabase.getAllStudentsByAddress(address);
    filter = address;
    notifyListeners();
  }

  void refreshStudentList() {
    if (filter == "All") {
      getAllStudents();
    } else {
      getAllStudentsByAddress(filter);
    }
  }

  void insertStudent(StudentModel student) async {
    await StudentDatabase.insertStudent(
      name: student.name ?? '',
      age: student.age ?? -1,
      address: student.address ?? '',
      major: student.major ?? '',
      phone: student.phone ?? '',
      photo: student.photo,
    );
    getUniqueAddressList();
    refreshStudentList();
  }

  void updateStudent({
    required int id,
    required String address,
    required String phone,
  }) async {
    await StudentDatabase.updateStudent(
      address: address,
      phone: phone,
      id: id,
    );
    getUniqueAddressList();
    refreshStudentList();
  }

  void deleteStudent(int id) async {
    await StudentDatabase.deleteStudent(id);
    getUniqueAddressList();
    refreshStudentList();
  }
}
