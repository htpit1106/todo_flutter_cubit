import 'package:equatable/equatable.dart';
import 'package:todo_app/model/entities/todo_entity.dart';

class AddTaskState extends Equatable {
  final TodoEntity todo;
  final bool isLoading;

  const AddTaskState({
    required this.todo,

    this.isLoading = false,
  });

  AddTaskState copyWith({
    TodoEntity? todo,
    bool? isLoading,
  }) {
    return AddTaskState(
      todo: todo ?? this.todo,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [todo, isLoading];
}
