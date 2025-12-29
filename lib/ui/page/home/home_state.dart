import 'package:equatable/equatable.dart';
import 'package:todo_app/model/entities/todo_entity.dart';

class HomeState extends Equatable {
  final bool loadingList;
  final List<TodoEntity> todos;


  const HomeState({
    this.loadingList = false,
    this.todos = const [],

  });

  List<TodoEntity> get completedTodos =>
      todos.where((e) => e.isCompleted == true).toList();

  List<TodoEntity> get unCompletedTodos =>
      todos.where((e) => e.isCompleted == false).toList();

  HomeState copyWith({
    bool? loadingList,
    List<TodoEntity>? todos,
  }) {
    return HomeState(
      loadingList: loadingList ?? this.loadingList,
      todos: todos ?? this.todos,

    );
  }

  @override
  List<Object?> get props => [loadingList, todos];
}
