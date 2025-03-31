import 'package:flutter/material.dart';
import 'package:lessoon_storage/models/student_model.dart';
import 'package:lessoon_storage/notifiers/student_database_notifier.dart';
import 'package:lessoon_storage/widgets/student_form.dart';
import 'package:lessoon_storage/widgets/sutudent_edit_page.dart';
import 'package:provider/provider.dart';
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
  await StudentDatabaseNotifier.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudentDatabaseNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MenuController _filterController = MenuController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentDatabaseNotifier>(context, listen: false)
        ..getAllStudents()
        ..getUniqueAddressList();
    });
  }

  @override
  Widget build(BuildContext context) {
    StudentDatabaseNotifier notifier = Provider.of(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Student Database"),
          actions: [
            Consumer<StudentDatabaseNotifier>(
                builder: (context, studentNotifier, child) {
              List<String> addressList = studentNotifier.uniqueAddressList;
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
                        notifier.getAllStudents();
                      },
                    ),
                  for (int i = 0; i < addressList.length; i++)
                    MenuItemButton(
                      onPressed: () {
                        notifier.getAllStudentsByAddress(addressList[i]);
                      },
                      child: Text(addressList[i]),
                    )
                ],
              );
            })
          ],
        ),
        body: Consumer<StudentDatabaseNotifier>(
            builder: (context, studentProvider, child) {
          List<StudentModel> students = studentProvider.studentList;
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
                                            studentModel: student,
                                          ),
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
                                    notifier.deleteStudent(student.id!);
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
        }),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Add new student"),
                      content: StudentForm(),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
