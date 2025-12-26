import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/entities/todo_entity.dart';
import 'package:todo_app/model/enum/category.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/ui/page/add_task/add_task_navigator.dart';
import 'package:todo_app/ui/page/add_task/add_task_state.dart';
import 'package:todo_app/utils/app_date_utils.dart';

import '../../../main.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final AddTaskNavigator navigator;
  final TodoRepository todoRepos;

  AddTaskCubit({required this.navigator, required this.todoRepos})
    : super(AddTaskState(date: DateTime.now(), time: TimeOfDay.now(), category: Category.task));

  void initialData(TodoEntity? todo) {
    if (todo != null) {
      final date = AppDateUtils.toDateTime(todo.time!);
      final time = AppDateUtils.toTimeOfDay(date);

      emit(state.copyWith(date: date, time: time, category: todo.category));
    }

  }

  void setDate(DateTime date) {

    emit(state.copyWith(date: date));
  }

  void setTime(TimeOfDay time) {
    emit(state.copyWith(time: time));
  }

  void setCategory(Category category) {
    emit(state.copyWith(category: category));
  }
  Future<void> saveTask({TodoEntity? todo, String? title, String? notes}) async  {
    try {

      // update
      if (todo != null && todo.id != null) {
        TodoEntity updatedTodo = todo.copyWith(
          title: title,
          notes: notes,
          category: state.category,
          time: AppDateUtils.dateToStringISO8601(state.date, state.time),
        );

        await todoRepos.updateTodo(todo.id!, updatedTodo);

      }
      // add task
      else {
        final userId = supabase.auth.currentUser?.id;

        TodoEntity newTodo = TodoEntity(
            isCompleted: false,
            category: state.category,
            time: AppDateUtils.dateToStringISO8601(state.date, state.time),
            title: title,
            notes: notes,
            userId: userId,
            createdAt: AppDateUtils.dateToStringISO8601(DateTime.now(), TimeOfDay.now())
        );

        await todoRepos.addNewTask(newTodo);
      }

      goBackHome(result: true);

    } catch (e) {
      debugPrint("save task error: $e");

    }
  }
  void goBackHome({bool? result}) {
    navigator.goBackHome(result: result);
  }
}
