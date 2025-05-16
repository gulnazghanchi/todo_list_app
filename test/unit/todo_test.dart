import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/models/todo.dart';

import 'package:flutter/material.dart';

void main() {
  group('Todo', () {
    test('should create a Todo instance with required parameters', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
      );

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, false); // Default value
    });

    test('should create a Todo instance with all parameters', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        isCompleted: true,
      );

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, true);
    });

    test('should create different Todo instances with different IDs', () {
      final todo1 = Todo(
        id: '1',
        title: 'First Todo',
      );

      final todo2 = Todo(
        id: '2',
        title: 'Second Todo',
      );

      expect(todo1.id, isNot(equals(todo2.id)));
    });

    test('should allow title to be empty string', () {
      final todo = Todo(
        id: '1',
        title: '',
      );

      expect(todo.title, isEmpty);
    });

    test('should allow isCompleted to be changed after creation', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
      );

      expect(todo.isCompleted, false);
      
      todo.isCompleted = true;
      expect(todo.isCompleted, true);
      
      todo.isCompleted = false;
      expect(todo.isCompleted, false);
    });
  });

  group('Todo Completion', () {
    late List<Todo> todos;
    late Function(String) toggleTodo;

    setUp(() {
      todos = [
        Todo(id: '1', title: 'First Todo'),
        Todo(id: '2', title: 'Second Todo'),
        Todo(id: '3', title: 'Third Todo'),
      ];

      toggleTodo = (String id) {
        final todo = todos.firstWhere((todo) => todo.id == id);
        todo.isCompleted = !todo.isCompleted;
      };
    });

    test('should toggle todo completion status', () {
      // Initial state - all todos are incomplete
      for (var todo in todos) {
        expect(todo.isCompleted, false);
      }

      // Complete the first todo
      toggleTodo('1');
      expect(todos[0].isCompleted, true);
      expect(todos[1].isCompleted, false);
      expect(todos[2].isCompleted, false);

      // Complete the second todo
      toggleTodo('2');
      expect(todos[0].isCompleted, true);
      expect(todos[1].isCompleted, true);
      expect(todos[2].isCompleted, false);

      // Uncomplete the first todo
      toggleTodo('1');
      expect(todos[0].isCompleted, false);
      expect(todos[1].isCompleted, true);
      expect(todos[2].isCompleted, false);
    });

    test('should handle multiple toggles on the same todo', () {
      final todo = todos[0];
      expect(todo.isCompleted, false);

      toggleTodo(todo.id);
      expect(todo.isCompleted, true);

      toggleTodo(todo.id);
      expect(todo.isCompleted, false);

      toggleTodo(todo.id);
      expect(todo.isCompleted, true);
    });

    test('should not affect other todos when toggling one todo', () {
      // Set initial states
      todos[0].isCompleted = true;
      todos[1].isCompleted = true;
      
      // Toggle middle todo
      toggleTodo('2');
      
      // Verify only middle todo changed
      expect(todos[0].isCompleted, true);
      expect(todos[1].isCompleted, false);
      expect(todos[2].isCompleted, false);
    });
  });
}
