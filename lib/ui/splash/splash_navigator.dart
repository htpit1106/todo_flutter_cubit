import 'package:todo_app/common/app_navigator.dart';
import 'package:todo_app/router/app_router.dart';
class SplashNavigator extends AppNavigator {
  SplashNavigator({required super.context});


  void goHome() {
    pushReplacementNamed(AppRouter.home);
  }
  void goLogin() {
    pushReplacementNamed(AppRouter.logIn);
  }

  void goOnboarding(){
    pushReplacementNamed(AppRouter.onboarding);
  }
}
