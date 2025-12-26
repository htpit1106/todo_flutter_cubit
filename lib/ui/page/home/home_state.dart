import 'package:equatable/equatable.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/model/entities/todo_entity.dart';

class HomeState extends Equatable {
  final bool loadingList;
  final List<TodoEntity> todos;
  final ProfileEntity? profile;

  const HomeState({
    this.loadingList = false,
    this.todos = const [],
    this.profile,
  });

  List<TodoEntity> get completedTodos =>
      todos.where((e) => e.isCompleted == true).toList();

  List<TodoEntity> get unCompletedTodos =>
      todos.where((e) => e.isCompleted == false).toList();

  HomeState copyWith({
    bool? loading,
    List<TodoEntity>? todos,
    ProfileEntity? profile,
  }) {
    return HomeState(
      loadingList: loading ?? this.loadingList,
      todos: todos ?? this.todos,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [loadingList, todos, profile];
}
