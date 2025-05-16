class Todo {
  String id;
  String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}
