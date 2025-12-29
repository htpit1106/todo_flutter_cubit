import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/global/user_state.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/repository/profile_repository.dart';

class UserCubit extends Cubit<UserState> {
  final SupabaseClient supabase;
  final ProfileRepository profileRepo;
  UserCubit({required this.profileRepo, required this.supabase}): super(const UserState());
  late final _user = supabase.auth.currentUser;

  Future <void> loadProfile() async {
    if (_user == null ) {
      return;
    }
    final profile = await profileRepo.getProfileById(_user.id);
    emit(state.copyWith(profile: profile));
  }

  Future <void> updateProfile(ProfileEntity profile) async {
    if (_user == null) {
      return;
    }
    await profileRepo.updateProfile(profile, _user.id);
    await loadProfile();
  }

  void clear() {
    emit(const UserState());

  }

}