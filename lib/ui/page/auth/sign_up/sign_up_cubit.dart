import 'package:bloc/bloc.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/ui/page/auth/sign_up/sign_up_navigator.dart';
import 'package:todo_app/ui/page/auth/sign_up/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpNavigator navigator;
  final AuthRepository authRepos;
  final UserCubit userCubit;


  SignUpCubit({required this.navigator, required this.authRepos, required this.userCubit}) : super(const SignUpState());

  // set name
  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  // set email
  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  // set password
  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

// set confirm password
  void setConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  // signup
  Future<void> onPressSignUp() async {
    await authRepos.signUp(state.email, state.password);
    await userCubit.loadProfile();
    navigator.goHome();
  }

  void onPressLogIn() {
    navigator.goLogin();
  }
}
