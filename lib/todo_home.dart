import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key});

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fixMissingIsDoneField();
  }

  Future<void> _fixMissingIsDoneField() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .where('isDone', isNull: true)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isDone': false});
    }
  }

  Future<void> _addTask(String text) async {
    if (text.trim().isEmpty) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add({'name': text.trim(), 'isDone': false});
    _controller.clear();
  }

  Future<void> _toggleTask(DocumentSnapshot doc) async {
    try {
      final current = doc['isDone'];
      if (current is bool) {
        await doc.reference.update({'isDone': !current});
      } else {
        await doc.reference.update({'isDone': true});
      }
    } catch (e) {
      print('Error al cambiar el estado de la tarea: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar la tarea')),
      );
    }
  }

  Future<void> _deleteTask(DocumentSnapshot doc) async {
    await doc.reference.delete();
  }

  Future<void> _editTask(DocumentSnapshot doc) async {
    final TextEditingController editController = TextEditingController(
      text: doc['name'],
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nuevo nombre de la tarea',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final newName = editController.text.trim();
              Navigator.pop(context, newName);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await doc.reference.update({'name': result});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .orderBy('name');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Nueva tarea'),
                    onSubmitted: _addTask,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasksRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No hay tareas aún'));
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return ListTile(
                      leading: Checkbox(
                        value: doc['isDone'] == true,
                        onChanged: (_) => _toggleTask(doc),
                      ),
                      title: GestureDetector(
                        onTap: () => _editTask(doc),
                        child: Text(
                          doc['name'],
                          style: TextStyle(
                            decoration: doc['isDone'] == true
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(doc),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
