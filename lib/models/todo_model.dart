class Todo {
  final String task;
  final bool completed;
  final bool starred;

  Todo({
    required this.task,
    this.completed = false,
    this.starred = false,
  });

  Todo copyWith({
    String? task,
    bool? completed,
    bool? starred,
  }) {
    return Todo(
      task: task ?? this.task,
      completed: completed ?? this.completed,
      starred: starred ?? this.starred,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'completed': completed,
      'starred': starred,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      task: json['task'] as String,
      completed: json['completed'] as bool? ?? false,
      starred: json['starred'] as bool? ?? false,
    );
  }
}
