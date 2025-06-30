import 'package:flutter/material.dart';
import 'universal_db_helper.dart';

void main() => runApp(const ToDoApp());

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tareas',
      home: const ToDoHome(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF232946),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF393E6A),
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
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

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key});

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await UniversalDBHelper.getTasks();
    setState(() {
      _tasks = data.map((e) => Task.fromMap(e)).toList();
    });
  }

  Future<void> _addTask(String taskText) async {
    if (taskText.trim().isEmpty) return;
    final task = Task(name: taskText.trim());
    await UniversalDBHelper.insertTask(task.toMap());
    _controller.clear();
    await _loadTasks();
  }

  Future<void> _toggleTask(int index) async {
    final task = _tasks[index];
    task.isDone = !task.isDone;
    await UniversalDBHelper.updateTask(task.id!, task.toMap());
    await _loadTasks();
  }

  Future<void> _deleteTask(int index) async {
    final task = _tasks[index];
    await UniversalDBHelper.deleteTask(task.id!);
    await _loadTasks();
  }

  Future<void> _editTask(int index) async {
    final task = _tasks[index];
    final editController = TextEditingController(text: task.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF393E6A),
        title: const Text(
          'Editar tarea',
          style: TextStyle(color: Colors.deepPurple),
        ),
        content: TextField(
          controller: editController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Editar tarea',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.deepPurple),
            ),
            onPressed: () => Navigator.pop(context, editController.text),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      task.name = result.trim();
      await UniversalDBHelper.updateTask(task.id!, task.toMap());
      await _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tareas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF393E6A),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Nueva tarea',
                        prefixIcon: Icon(
                          Icons.edit_note_rounded,
                          color: Colors.deepPurple,
                        ),
                      ),
                      onSubmitted: (value) async => await _addTask(value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async => await _addTask(_controller.text),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No hay tareas aún',
                      style: TextStyle(color: Colors.white54, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 2,
                        ),
                        color: const Color(0xFF393E6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) async => await _toggleTask(index),
                          ),
                          title: Text(
                            task.name,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () async => await _editTask(index),
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async => await _deleteTask(index),
                                tooltip: 'Eliminar',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Task {
  int? id;
  String name;
  bool isDone;

  Task({this.id, required this.name, this.isDone = false});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'name': name, 'isDone': isDone ? 1 : 0};
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(id: map['id'], name: map['name'], isDone: map['isDone'] == 1);
  }
}
