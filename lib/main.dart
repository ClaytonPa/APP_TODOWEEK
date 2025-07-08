import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tareas',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        checkboxTheme: const CheckboxThemeData(
          fillColor: WidgetStatePropertyAll(Colors.deepPurple),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(Colors.amberAccent),
          ),
        ),
      ),
    );
  }
}
