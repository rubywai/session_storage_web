import 'dart:io';

import 'package:lessoon_storage/models/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StudentDatabase {
  static late Database _db;
  static final String _studentTable = "students";
  static Future<Database> createDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = "${directory.path}/student.db";
    final database = await openDatabase(
      dbPath,
      version: 1,
    );
    _db = database;
    return database;
  }

  static Future<void> createStudentTable() {
    return _db.execute(
        "create table if not exists $_studentTable (id integer primary key autoincrement,name text,age integer,address text,major text,phone text)");
  }

  static Future<void> insertStudent({
    required String name,
    required int age,
    required String address,
    required String major,
    required String phone,
  }) {
    return _db.execute(
        'insert into $_studentTable (name,age,address,major,phone) values ("$name",$age,"$address","$major","$phone")');
  }

  static Future<List<StudentModel>> getAllStudents() async {
    final rawResult = await _db.rawQuery("select * from $_studentTable");
    return rawResult.map((e) {
      return StudentModel.fromMap(e);
    }).toList();
  }

  static Future<void> updateStudent({
    required String address,
    required String phone,
    required int id,
  }) {
    return _db.execute(
        'update $_studentTable set address = "$address",phone = "$phone" where id = $id');
  }
}
