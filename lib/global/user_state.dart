import 'package:equatable/equatable.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';

class UserState extends Equatable {
  final ProfileEntity? profile;
  const UserState({this.profile});

  UserState copyWith({
    ProfileEntity? profile,
  }) {
    return  UserState(
      profile: profile ?? this.profile,
    );
  }
  @override
  List<Object?> get props => [profile];

}