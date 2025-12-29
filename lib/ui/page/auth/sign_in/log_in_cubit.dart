import 'package:bloc/bloc.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/repository/auth_repository.dart';

import 'log_in_navigator.dart';
import 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  final LogInNavigator navigator;
  final AuthRepository authRepos;
  final UserCubit userCubit;

  LogInCubit({required this.navigator, required this.authRepos, required this.userCubit})
    : super(const LogInState());

  // set email
  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  // set password
  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> onPressLogin() async {
    await authRepos.logIn(state.email, state.password);
    await userCubit.loadProfile();
    navigator.goHome();
  }

  void onPressSignup() {
    navigator.goSignUp();
  }
}
