import 'package:bloc/bloc.dart';
import 'package:todo_app/global/user_state.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/repository/profile_repository.dart';

class UserCubit extends Cubit<UserState> {
  final ProfileRepository profileRepo;
  UserCubit({required this.profileRepo}): super(const UserState());
  final user = supabase.auth.currentUser;
  Future <void> loadUser() async {

    if (user == null ) {
      return;
    }

    final profile = await profileRepo.getProfileById(user!.id);
    emit(state.copyWith(profile: profile));
  }

  Future <void> updateProfile(ProfileEntity profile) async {
    if (user == null) {
      return;
    }
    await profileRepo.updateProfile(profile, user!.id);
    await loadUser();
  }

  void clear() {
    emit(const UserState());

  }

}