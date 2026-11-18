import 'package:flutter/material.dart';
import '../data/local_database.dart';
import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final LocalDatabase database = LocalDatabase();
  final TextEditingController controller = TextEditingController();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final result = await database.getAllTasks();

    setState(() {
      tasks = result;
    });
  }

  Future<void> addTask() async {
    if (controller.text.trim().isEmpty) return;

    await database.insertTask(
      Task(title: controller.text.trim()),
    );

    controller.clear();
    loadTasks();
  }

  Future<void> toggleTask(Task task) async {
    await database.updateTask(
      Task(
        id: task.id,
        title: task.title,
        isCompleted: !task.isCompleted,
      ),
    );

    loadTasks();
  }

  Future<void> removeTask(int id) async {
    await database.deleteTask(id);
    loadTasks();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    removeTask(task.id!);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    value: task.isCompleted,
                    onChanged: (value) {
                      toggleTask(task);
                    },
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