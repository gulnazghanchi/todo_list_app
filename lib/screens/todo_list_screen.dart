import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import 'posts_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  final _textController = TextEditingController();
  final _uuid = Uuid();

  void _addTodo(String title) {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please enter a task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
          elevation: 4,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _todos.add(Todo(
        id: _uuid.v4(),
        title: title.trim(),
      ));
    });
    _textController.clear();
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.article_outlined),
            color: Theme.of(context).colorScheme.onPrimary,
            tooltip: 'View Posts',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostsScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onFieldSubmitted: (value) => _addTodo(value),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _addTodo(_textController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a task to get started!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: todo.isCompleted,
                                onChanged: (_) => _toggleTodo(todo.id),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                fontSize: 16,
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isCompleted
                                    ? Colors.grey[400]
                                    : Colors.grey[800],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.grey[600],
                              ),
                              onPressed: () => _deleteTodo(todo.id),
                            ),
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
