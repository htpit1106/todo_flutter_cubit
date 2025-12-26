import 'package:bloc/bloc.dart';
import 'package:todo_app/database/share_preferences_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/ui/splash/splash_navigator.dart';
import 'package:todo_app/ui/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashNavigator navigator;
  SplashCubit({required this.navigator}) : super(SplashState());

  Future <void> autoLogin () async {
    // is first run
    final isFistRun = await SharedPreferencesHelper.isFirstRun();
    if (isFistRun) {
      navigator.goOnboarding();
      await SharedPreferencesHelper.setFirstRun();
      return;
    }


    final session = supabase.auth.currentSession;
    session != null ? navigator.goHome() : navigator.goLogin();
  }

}
