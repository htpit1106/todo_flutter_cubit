import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/model/entities/todo_entity.dart';
import 'package:todo_app/repository/profile_repository.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/ui/page/home/home_navigator.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeNavigator navigator;
  final TodoRepository todoRepo;
  final ProfileRepository profileRepo;

  HomeCubit({
    required this.navigator,
    required this.todoRepo,
    required this.profileRepo,
  }) : super(const HomeState());

  String get _userId => supabase.auth.currentUser!.id;

  //
  Future<void> fetchInitialData() async {
    emit(state.copyWith(loading: true));

    try {
      final results = await Future.wait([
        todoRepo.getTodos(_userId),
        profileRepo.getProfileById(_userId),
      ]);

      emit(state.copyWith(
        todos: results[0] as List<TodoEntity>,
        profile: results[1] as ProfileEntity,
        loading: false,
      ));
    } catch (e) {
      debugPrint('Home fetch error: $e');
      emit(state.copyWith(loading: false));
    }
  }


  Future<void> fetchTodos() async {
    try {
      final todos = await todoRepo.getTodos(_userId);
      emit(state.copyWith(todos: todos));
    } catch (e) {
      debugPrint('get todo error: $e');
    }
  }


  Future<void> onPressAvatar() async {
    final updatedProfile =
    await navigator.openProfilePage<ProfileEntity>(state.profile);

    if (updatedProfile != null) {
      emit(state.copyWith(profile: updatedProfile));
    }
  }


  Future<void> toggleCompleted(String id, bool isCompleted) async {
    await todoRepo.toggleCompleted(id, isCompleted);
    fetchTodos();
  }


  Future<void> deleteTask(String id) async {
    final newTodos = List<TodoEntity>.from(state.todos)
      ..removeWhere((e) => e.id == id);
    emit(state.copyWith(todos: newTodos));

    try {
      await todoRepo.deleteTask(id);
    } catch (e) {
      debugPrint('delete todo error: $e');
      // (optional) rollback nếu cần
    }
  }


  Future<void> onPressItem(TodoEntity todo) async {
    final result = await navigator.openDetailTask<bool>(todo);
    if (result == true) {
      fetchTodos();
    }
  }


  Future<void> onPressAddTaskBtn() async {
    final result = await navigator.openNewTaskPage<bool>();
    if (result == true) {
      fetchTodos();
    }
  }
}

