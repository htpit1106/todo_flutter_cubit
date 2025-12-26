import 'package:go_router/go_router.dart';
import 'package:todo_app/common/app_navigator.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/model/entities/todo_entity.dart';
import 'package:todo_app/router/app_router.dart';

class HomeNavigator extends AppNavigator {
  HomeNavigator({required super.context});

  Future<T?> openNewTaskPage<T>() {
    return context.push<T>(AppRouter.addTask);
  }

  Future<T?> openDetailTask<T>(TodoEntity todo) {
    return context.push(AppRouter.addTask, extra: todo);
  }

  Future<T?> openProfilePage<T>(ProfileEntity? profile){
   return  context.push(AppRouter.profile, extra: profile);
  }
}
