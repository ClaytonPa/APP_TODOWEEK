import 'package:flutter/foundation.dart' show kIsWeb;
import 'db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UniversalDBHelper {
  static Future<List<Map<String, dynamic>>> getTasks() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('tasks');
      if (jsonString == null) return [];
      final List decoded = jsonDecode(jsonString);
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      return await DBHelper.getTasks();
    }
  }

  static Future<void> insertTask(Map<String, dynamic> task) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final tasks = await getTasks();
      int newId = tasks.isEmpty
          ? 1
          : (tasks
                    .map((e) => e['id'] as int? ?? 0)
                    .reduce((a, b) => a > b ? a : b) +
                1);
      task['id'] = newId;
      tasks.add(task);
      await prefs.setString('tasks', jsonEncode(tasks));
    } else {
      await DBHelper.insertTask(task);
    }
  }

  static Future<void> updateTask(int id, Map<String, dynamic> task) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final tasks = await getTasks();
      final idx = tasks.indexWhere((e) => e['id'] == id);
      if (idx != -1) {
        tasks[idx] = task;
        await prefs.setString('tasks', jsonEncode(tasks));
      }
    } else {
      await DBHelper.updateTask(id, task);
    }
  }

  static Future<void> deleteTask(int id) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final tasks = await getTasks();
      tasks.removeWhere((e) => e['id'] == id);
      await prefs.setString('tasks', jsonEncode(tasks));
    } else {
      await DBHelper.deleteTask(id);
    }
  }
}
