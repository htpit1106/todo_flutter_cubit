import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/configs/app_constants.dart';
import 'package:todo_app/model/entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos(String userId);

  Future<void> toggleCompleted(String id, bool isCompleted);

  Future<void> updateTodo(String id, TodoEntity todo);

  Future<bool> addNewTask(TodoEntity todo);

  Future<void> deleteTask(String id);
}

class TodoRepositorImpl extends TodoRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<bool> addNewTask(TodoEntity todo) async {
    final res = await _supabase
        .from(AppConstants.todoTableName)
        .insert(todo.toJsonInsert())
        .select();
    if (res.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<void> deleteTask(String id) async {
    await _supabase.from(AppConstants.todoTableName).delete().eq('id', id);
  }

  @override
  Future<List<TodoEntity>> getTodos(String userId) async {
    final data = await _supabase.from(AppConstants.todoTableName).select().eq('user_id', userId);
    return data.map((e) => TodoEntity.fromJson(e)).toList();
  }

  @override
  Future<void> toggleCompleted(String id, bool isCompleted) async {
    await _supabase
        .from(AppConstants.todoTableName)
        .update({'is_completed': !isCompleted})
        .eq('id', id);
  }

  @override
  Future<void> updateTodo(String id, TodoEntity todo) async {
    await _supabase.from(AppConstants.todoTableName).update(todo.toJson()).eq('id', id);
  }
}
