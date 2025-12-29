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
  final TodoEntity? todo;

  AddTaskCubit({required this.navigator, required this.todoRepos, required this.todo})
    : super(
        AddTaskState(
          todo:
              todo ??
              TodoEntity(
                isCompleted: false,
                category: Category.task,
                time: AppDateUtils.dateToStringISO8601(DateTime.now(), TimeOfDay.now()),
                createdAt: AppDateUtils.dateToStringISO8601(DateTime.now(), TimeOfDay.now()),
              ),
          isLoading: false,
        ),
      );

  // get date
  DateTime get date {

    return todo!.time == null ? DateTime.now() : DateTime.parse(todo!.time!);
  }

  // get time of day
  TimeOfDay get time {
    if (todo == null) return TimeOfDay.now();
    return todo!.time == null ? TimeOfDay.now() : TimeOfDay.fromDateTime(DateTime.parse(todo!.time!));
  }
  void initialData(TodoEntity? todo) {
    if (todo != null) {
      emit(state.copyWith(todo: todo));
    }
  }

  // set category
  void setCategory(Category category) {
    emit(state.copyWith(todo: state.todo.copyWith(category: category)));
  }

  // set date
  void setDate(DateTime? date) {
    DateTime time = todo!.time == null ? DateTime.now() : DateTime.parse(todo!.time!);
    final timeOfDay = TimeOfDay(hour: time.hour, minute: time.minute);
    final dateString = AppDateUtils.dateToStringISO8601(date ?? time, timeOfDay);
    emit(state.copyWith(todo: state.todo.copyWith(time: dateString)));
  }

  // set time
  void setTime(TimeOfDay? time) {
    DateTime date = todo!.time == null ? DateTime.now() : DateTime.parse(todo!.time!);

    final dateString = AppDateUtils.dateToStringISO8601(date, time ?? TimeOfDay.now());
    emit(state.copyWith(todo: state.todo.copyWith(time: dateString)));
  }

  Future<void> saveTask({TodoEntity? todo, String? title, String? notes}) async {
    try {
      // update
      if (todo != null && todo.id != null) {
        TodoEntity updatedTodo = todo.copyWith(
          title: title,
          notes: notes,
          category: state.todo.category,
          time: state.todo.time,
        );
        await todoRepos.updateTodo(todo.id!, updatedTodo);
      }
      // add task
      else {
        final userId = supabase.auth.currentUser?.id;

        TodoEntity newTodo = TodoEntity(
          isCompleted: false,
          category: state.todo.category,
          time: state.todo.time,
          title: title,
          notes: notes,
          userId: userId,
          createdAt: AppDateUtils.dateToStringISO8601(DateTime.now(), TimeOfDay.now()),
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
