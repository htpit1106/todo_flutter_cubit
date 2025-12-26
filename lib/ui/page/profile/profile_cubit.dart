import 'package:bloc/bloc.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/ui/page/profile/profile_navigator.dart';
import 'package:todo_app/ui/page/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState>{
  final ProfileNavigator navigator;
  final AuthRepository authRepo;

  ProfileCubit({required this.authRepo, required this.navigator}): super(const ProfileState());


  void onPressUpdateProfile() {
    navigator.goUpdatePage();
  }

  void onBackHome() {
    navigator.goBackHome();
  }

  void onPressLogOut() {
    navigator.goLogOut(authRepo);
  }
}
