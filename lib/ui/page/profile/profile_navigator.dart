import 'package:go_router/go_router.dart';
import 'package:todo_app/common/app_navigator.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/router/app_router.dart';

class ProfileNavigator extends AppNavigator {

  ProfileNavigator({required super.context});


  void goUpdatePage(){
    context.push(AppRouter.updateProfile);
  }

  void goBackHome(){
    context.pop();
  }

  void goLogOut(AuthRepository authRepo) {
    authRepo.logOut();
    context.pushReplacementNamed(AppRouter.logIn);
  }


}