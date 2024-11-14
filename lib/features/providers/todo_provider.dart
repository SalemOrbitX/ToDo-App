import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/features/data/models/todo_model.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');

    if (todosJson != null) {
      final List<dynamic> todoList = jsonDecode(todosJson);
      state = todoList.map((json) => Todo.fromJson(json)).toList();
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson =
        jsonEncode(state.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosJson);
  }

  void addTodo(Todo todo) {
    state = [...state, todo];
    saveTodos();
  }

  void updateTodo(int index, Todo todo) {
    state[index] = todo;
    state = [...state];
    saveTodos();
  }

  void deleteTodo(int index) {
    state = [...state]..removeAt(index);
    saveTodos();
  }

  void toggleCompletion(int index) {
    final todo = state[index];
    updateTodo(index, todo.copyWith(completed: !todo.completed));
  }

  void toggleStar(int index) {
    final todo = state[index];
    updateTodo(index, todo.copyWith(starred: !todo.starred));
  }

  void sortTodos() {
    state = [...state]..sort((a, b) => a.task.compareTo(b.task));
    saveTodos();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
