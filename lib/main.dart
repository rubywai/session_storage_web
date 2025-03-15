import 'package:flutter/material.dart';
import 'storage/storage_common.dart';
import 'storage/my_preference_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPreferenceStorage.initStorage();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  @override
  void initState() {
    super.initState();
    bool? theme = getTheme();
    if (theme == true) {
      _themeMode = ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        onThemeChange: (value) {
          setState(() {
            _themeMode = value ? ThemeMode.dark : ThemeMode.light;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.onThemeChange});
  final Function(bool) onThemeChange;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkTheme = false;
  bool _isRemember = false;
  String _groupValue = "user";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    bool? isDarkTheme = getTheme();
    if (isDarkTheme == true) {
      _isDarkTheme = true;
    }
    _emailController.text = getEmail() ?? '';
    _passwordController.text = getPassword() ?? '';
    _isRemember = getRemember() ?? false;
    _groupValue = getUserType() ?? "user";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch.adaptive(
            value: _isDarkTheme,
            onChanged: (value) {
              setState(() {
                _isDarkTheme = value;
              });
              widget.onThemeChange(value);
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'Email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'Password'),
            ),
            SizedBox(height: 8.0),
            CheckboxListTile(
              title: Text('Remember'),
              value: _isRemember,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    _isRemember = value;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text('User Type:'),
                Radio(
                  value: "user",
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = value!;
                    });
                  },
                ),
                Text('User'),
                Radio(
                  value: "admin",
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = value!;
                    });
                  },
                ),
                Text('Admin'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text;
                String password = _passwordController.text;

                saveLoginInfo(
                  isDarkTheme: _isDarkTheme,
                  email: email,
                  password: password,
                  isRemember: _isRemember,
                  userType: _groupValue,
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
