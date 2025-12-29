import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/configs/app_constants.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
abstract class ProfileRepository {
  final SupabaseClient supabase ;
  ProfileRepository({required this.supabase});
  Future<ProfileEntity> getProfileById(String id);

  Future<void> addProfile(ProfileEntity profile);

  Future<void> updateProfile(ProfileEntity profile, String id);
  Future<String?> uploadImage(File imageFile, String userId);
}

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl({required super.supabase});

  @override
  Future<ProfileEntity> getProfileById(String id) async {
    final data = await supabase.from('profile').select().eq('id', id);
    // check null
    if (data.isEmpty) {
      return ProfileEntity();
    }
    return ProfileEntity.fromJson(data.first);
  }

  @override
  Future<void> addProfile(ProfileEntity profile) async {
    final res = await supabase.from(AppConstants.profileTableName).insert(profile.toJson()).select();
    if (res.isEmpty) {
      debugPrint("Error add profile");
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile, String id) async {
    try {
    await supabase.from(AppConstants.profileTableName).update(profile.toJson()).eq('id', id).select();

    } catch (e) {
      debugPrint("error update");
    }
  }
  @override
  Future<String?> uploadImage(File imageFile, String userId) async {
    final fileExtension = imageFile.path.split('.').last;
    final fileName = 'public/$userId/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    try {
      await supabase.storage
          .from(AppConstants.bucketId)
          .upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(
          cacheControl: '3600',
          upsert: true,
        ), // upsert: true - override  existing file
      );
      return supabase.storage.from(AppConstants.bucketId).getPublicUrl(fileName);
    } catch (e) {
      debugPrint(e.toString());
      return null;

    }
  }

}
