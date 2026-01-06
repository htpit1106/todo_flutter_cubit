import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/repository/profile_repository.dart';
import 'package:todo_app/ui/page/profile/update_profile/update_profile_navigator.dart';
import 'package:todo_app/ui/page/profile/update_profile/update_profile_state.dart';
import 'package:todo_app/utils/image_picker_helper.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileNavigator navigator;
  final UserCubit userCubit;

  final ProfileRepository profileRepo;

  UpdateProfileCubit({
    required this.navigator,
    required this.userCubit,
    required this.profileRepo,
  }) : super( UpdateProfileState(
    profile: userCubit.state.profile,
  ));


  //
  Future<void> pickAndUploadAvatar(ProfileEntity profile, ImageSourceType sourceType) async {
    final imageFile = await ImagePickerHelper.pickAvatar(sourceType);


    if (imageFile == null || profile.id == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      final avatarUrl = await profileRepo.uploadImage(imageFile, profile.id!);
      emit(state.copyWith(isLoading: false, tempAvatarUrl: avatarUrl));

    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // submit Update

  Future <void> submitUpdate(ProfileEntity profile) async {
    try{
      await userCubit.updateProfile(profile);
      navigator.goBackHome();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

}
