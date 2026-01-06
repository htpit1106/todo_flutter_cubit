import 'package:equatable/equatable.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';

class UpdateProfileState extends Equatable {
  final ProfileEntity? profile;
  final bool isLoading;
  final String? tempAvatarUrl;
  final String? error;

  const UpdateProfileState( {
    this.isLoading = false,
    this.tempAvatarUrl,
    this.error,
    this.profile,
  });

  // copy with
  UpdateProfileState copyWith({
    bool? isLoading,
    String? tempAvatarUrl,
    String? error,
    ProfileEntity? profile,


  }) {
    return UpdateProfileState(
      isLoading: isLoading ?? this.isLoading,
      tempAvatarUrl: tempAvatarUrl ?? this.tempAvatarUrl,
      error: error ?? this.error,
      profile: profile ?? this.profile,

    );

  }
  @override
  List<Object?> get props => [isLoading, tempAvatarUrl, error];

}