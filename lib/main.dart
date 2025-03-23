import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lessoon_storage/models/student_model.dart';
import 'package:lessoon_storage/storage/student_db.dart';
import 'package:lessoon_storage/widgets/student_form.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//storage
//shared preference
//external internal
//database (sqlite)
//provider

//widget , app lifecycle

//String (TEXT)
//int (INTEGER)
//num (REAL)
//Uint8List (BLOB) (binary large object)
// .db
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StudentDatabase.createDatabase();
  await StudentDatabase.createStudentTable();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Student Database"),
          actions: [
            MenuAnchor(
              builder: (context, controller, child) {
                return IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.filter_list),
                );
              },
              menuChildren: [],
            )
          ],
        ),
        body: FutureBuilder<List<StudentModel>>(
          future: StudentDatabase.getAllStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            } else if (snapshot.hasData) {
              List<StudentModel> students = snapshot.data ?? [];

              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  StudentModel student = students[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        student.name ?? '',
                      ),
                      subtitle: Text(
                        student.age?.toString() ?? '',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                student.address ?? '',
                              ),
                              Text(
                                student.phone ?? '',
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                bool? isInsert = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Add new student"),
                      content: StudentForm(),
                    );
                  },
                );
                if (isInsert == true && mounted) {
                  setState(() {});
                }
              },
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
