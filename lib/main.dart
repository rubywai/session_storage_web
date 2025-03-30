import 'package:flutter/material.dart';
import 'package:lessoon_storage/models/student_model.dart';
import 'package:lessoon_storage/storage/student_db.dart';
import 'package:lessoon_storage/widgets/student_form.dart';
import 'package:lessoon_storage/widgets/sutudent_edit_page.dart';
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
  final MenuController _filterController = MenuController();
  String filterKey = "All";
  Future<List<StudentModel>> _studentFuture = StudentDatabase.getAllStudents();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (filterKey == "All") {
      _studentFuture = StudentDatabase.getAllStudents();
    } else {
      _studentFuture = StudentDatabase.getAllStudentsByAddress(filterKey);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Student Database"),
          actions: [
            FutureBuilder<List<Map<String, Object?>>>(
              future: StudentDatabase.getUniqueAddressLit(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, Object?>>? addressMap = snapshot.data;
                  List<String> addressList = addressMap?.map((e) {
                        return e.values.first.toString();
                      }).toList() ??
                      [];
                  return MenuAnchor(
                    controller: _filterController,
                    builder: (context, controller, child) {
                      return IconButton(
                        tooltip: 'Sort by address',
                        onPressed: () {
                          _filterController.open();
                        },
                        icon: Icon(Icons.filter_list),
                      );
                    },
                    menuChildren: [
                      if (addressList.isNotEmpty)
                        MenuItemButton(
                          child: Text('All'),
                          onPressed: () {
                            setState(() {
                              filterKey = "All";
                            });
                          },
                        ),
                      for (int i = 0; i < addressList.length; i++)
                        MenuItemButton(
                          onPressed: () {
                            setState(() {
                              filterKey = addressList[i];
                            });
                          },
                          child: Text(addressList[i]),
                        )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return SizedBox.shrink();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<StudentModel>>(
          key: UniqueKey(),
          future: _studentFuture,
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
                  final MenuController menuController = MenuController();
                  StudentModel student = students[index];
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
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
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: MenuAnchor(
                                  controller: menuController,
                                  builder: (context, controller, child) {
                                    return IconButton(
                                      onPressed: () {
                                        menuController.open();
                                      },
                                      icon: Icon(Icons.more_vert),
                                    );
                                  },
                                  menuChildren: [
                                    MenuItemButton(
                                      onPressed: () async {
                                        bool? result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Edit Student"),
                                              content: EditStudent(
                                                  studentModel: student),
                                            );
                                          },
                                        );
                                        if (result == true) {
                                          setState(() {});
                                        }
                                      },
                                      child: Text("Edit"),
                                    ),
                                    MenuItemButton(
                                      onPressed: () async {
                                        await StudentDatabase.deleteStudent(
                                            student.id!);
                                        setState(() {});
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (student.photo != null)
                          SizedBox(
                            height: 100,
                            child: Image.memory(student.photo!),
                          ),
                      ],
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
