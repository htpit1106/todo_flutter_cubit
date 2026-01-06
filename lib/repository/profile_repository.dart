import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/configs/app_constants.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfileById(String id);

  Future<void> addProfile(ProfileEntity profile);

  Future<void> updateProfile(ProfileEntity profile, String id);

  Future<String?> uploadImage(File imageFile, String userId);
}

class ProfileRepositoryImpl extends ProfileRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<ProfileEntity> getProfileById(String id) async {
    final data = await _supabase.from('profile').select().eq('id', id);

    if (data.isEmpty) {
      return ProfileEntity();
    }
    return ProfileEntity.fromJson(data.first);
  }

  @override
  Future<void> addProfile(ProfileEntity profile) async {
    final res = await _supabase
        .from(AppConstants.profileTableName)
        .insert(profile.toJson())
        .select();
    if (res.isEmpty) {
      debugPrint("Error add profile");
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile, String id) async {
    try {
      await _supabase
          .from(AppConstants.profileTableName)
          .update(profile.toJson())
          .eq('id', id)
          .select();
    } catch (e) {
      debugPrint("error update");
    }
  }

  @override
  Future<String?> uploadImage(File imageFile, String userId) async {
    final fileExtension = imageFile.path.split('.').last;
    final fileName = 'public/$userId/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    try {
      await _supabase.storage
          .from(AppConstants.bucketId)
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ), // upsert: true - override  existing file
          );
      return _supabase.storage.from(AppConstants.bucketId).getPublicUrl(fileName);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
