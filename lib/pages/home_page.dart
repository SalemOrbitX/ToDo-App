import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController taskController = TextEditingController();

  void _addTask(WidgetRef ref) {
    if (taskController.text.isNotEmpty) {
      ref.read(todoProvider.notifier).addTodo(Todo(
            task: taskController.text,
          ));
      taskController.clear();
    }
  }

  void _editTask(int index, WidgetRef ref, BuildContext context) {
    taskController.text = ref.read(todoProvider)[index].task;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: "Task"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  ref.read(todoProvider.notifier).updateTodo(
                        index,
                        Todo(
                          task: taskController.text,
                          completed: ref.read(todoProvider)[index].completed,
                          starred: ref.read(todoProvider)[index].starred,
                        ),
                      );
                  Navigator.of(context).pop();
                  taskController.clear();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('AppBar'),
        ),
        backgroundColor: Colors.amberAccent.withOpacity(0.6),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: () {
              ref.read(todoProvider.notifier).sortTodos();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todoItem = todos[index];
                return Dismissible(
                  key: Key(todoItem.task),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    ref.read(todoProvider.notifier).deleteTodo(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task deleted')),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        todoItem.task,
                        style: TextStyle(
                          decoration: todoItem.completed
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: todoItem.completed,
                            onChanged: (value) {
                              ref
                                  .read(todoProvider.notifier)
                                  .toggleCompletion(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              todoItem.starred ? Icons.star : Icons.star_border,
                              color: todoItem.starred ? Colors.amber : null,
                            ),
                            onPressed: () {
                              ref.read(todoProvider.notifier).toggleStar(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTask(index, ref, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: taskController,
              decoration: const InputDecoration(
                hintText: 'Enter new task...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.add_task),
              ),
              onSubmitted: (value) => _addTask(ref),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45),
        child: FloatingActionButton(
          onPressed: () {
            _addTask(ref);
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
