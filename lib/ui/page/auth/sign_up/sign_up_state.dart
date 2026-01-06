import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;

  const SignUpState({
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
    this.name = "",
  });

  // copy with
  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
    );
  }
  @override
  List<Object?> get props => [email, password, confirmPassword, name];
}
