import 'package:equatable/equatable.dart';

class LogInState extends Equatable {
  final bool isLoading;

  final String email;
  final String password;

  const LogInState(
      {this.isLoading = false, this.email = "phuonggm204@gmail.com", this.password = "123456"});

  // copyWith
  LogInState copyWith({bool? isLoading, String? email, String? password}) {
    return LogInState(isLoading: isLoading ?? this.isLoading,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  @override
  List<Object?> get props => [isLoading, email, password];
}
