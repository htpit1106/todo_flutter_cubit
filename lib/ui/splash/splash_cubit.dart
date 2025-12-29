import 'package:bloc/bloc.dart';
import 'package:todo_app/database/share_preferences_helper.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/ui/splash/splash_navigator.dart';
import 'package:todo_app/ui/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashNavigator navigator;
  final UserCubit userCubit;
  final AuthRepository authRepos;

  SplashCubit({required this.navigator, required this.userCubit, required this.authRepos})
    : super(SplashState());

  Future<void> autoLogin() async {
    // is first run
    final isFistRun = await SharedPreferencesHelper.isFirstRun();
    if (isFistRun) {
      navigator.goOnboarding();
      await SharedPreferencesHelper.setFirstRun();
      return;
    }

    final isLoggedIn = authRepos.isLoggedIn();
    if (isLoggedIn) {
      await userCubit.loadProfile();
      navigator.goHome();
      return;
    }
    navigator.goLogin();
  }
}
