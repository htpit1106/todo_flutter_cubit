import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/enum/category.dart';

class AddTaskState extends Equatable {
  final DateTime date;
  final TimeOfDay time;
  final Category? category;
  final bool isLoading;

  const AddTaskState({
    required this.date,
    required this.time,
    this.category,
    this.isLoading = false,
  });

  factory AddTaskState.initial() {
    return AddTaskState(
      date: DateTime.now(),
      time: TimeOfDay.now(),
      category: null,
    );
  }

  AddTaskState copyWith({
    DateTime? date,
    TimeOfDay? time,
    Category? category,
    bool? isLoading,
  }) {
    return AddTaskState(
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [date, time, category, isLoading];
}
