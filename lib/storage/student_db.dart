import 'dart:io';

import 'package:flutter/services.dart';
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
      version: 4,
      onUpgrade: (db, oldVersion, newVersion) {
        Future(() {
          db.execute("alter table $_studentTable add column photo blob");
        });
      },
    );
    _db = database;
    return database;
  }

  static Future<void> createStudentTable() {
    return _db.execute(
        "create table if not exists $_studentTable (id integer primary key autoincrement,name text,age integer,address text,major text,phone text,photo blob)");
  }

  static Future<void> insertStudent({
    required String name,
    required int age,
    required String address,
    required String major,
    required String phone,
    required Uint8List? photo,
  }) {
    return _db.rawInsert(
      'insert into $_studentTable (name,age,address,major,phone,photo) values (?,?,?,?,?,?)',
      [name, age, address, major, phone, photo],
    );
  }

  static Future<List<StudentModel>> getAllStudents() async {
    final rawResult = await _db.rawQuery("select * from $_studentTable");
    return rawResult.map((e) {
      return StudentModel.fromMap(e);
    }).toList();
  }

  static Future<List<StudentModel>> getAllStudentsByAddress(
      String address) async {
    final rawResult = await _db
        .rawQuery('select * from $_studentTable where address="$address"');
    return rawResult.map((e) {
      return StudentModel.fromMap(e);
    }).toList();
  }

  static Future<void> updateStudent({
    required String address,
    required String phone,
    required int id,
  }) {
    return _db.rawUpdate(
      'update $_studentTable set address = ?,phone = ? where id = ?',
      [address, phone, id],
    );
  }

  static Future<void> deleteStudent(int id) {
    return _db.execute("delete from $_studentTable where id = $id");
  }

  static Future<List<Map<String, Object?>>> getUniqueAddressLit() async {
    return await _db.rawQuery("select distinct address from $_studentTable");
  }
}
