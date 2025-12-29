import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_images.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/ui/page/auth/sign_up/sign_up_cubit.dart';
import 'package:todo_app/ui/page/auth/sign_up/sign_up_navigator.dart';
import 'package:todo_app/ui/widgets/app_text_form_field.dart';
import 'package:todo_app/ui/widgets/button_purple.dart';
import 'package:todo_app/utils/app_validator.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) {
        return SignUpCubit(
          navigator: SignUpNavigator(context: context),
          authRepos: context.read<AuthRepository>(),
          userCubit: context.read<UserCubit>(),
        );
      },
      child: SignUpPageChild(),
    );
  }
}

class SignUpPageChild extends StatefulWidget {
  const SignUpPageChild({super.key});

  @override
  State<SignUpPageChild> createState() => _SignUpPageChildState();
}

class _SignUpPageChildState extends State<SignUpPageChild> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController = TextEditingController();
  final TextEditingController fullNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Image.asset(AppImages.signupImg, height: 128, width: 128, fit: BoxFit.cover),

              const SizedBox(height: 28),
              AppTextFormField(
                controller: fullNameTextController,
                hintText: S.of(context).hint_full_name,
                onChange: cubit.setName,
                validator: (value) =>
                    AppValidator.validateEmpty(value, S.of(context).valid_field_empty),
              ),
              AppTextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailTextController,
                hintText: S.of(context).hint_email,
                onChange: cubit.setEmail,
                validator: (value) => AppValidator.validateEmail(
                  value,
                  S.of(context).valid_email_enter,
                  S.of(context).valid_email_format,
                ),
              ),

              // password
              AppTextFormField(
                obscureText: true,
                controller: passwordTextController,
                hintText: S.of(context).hint_password,
                onChange: cubit.setPassword,
                validator: (value) =>
                    AppValidator.validatePassword(value, S.of(context).valid_password_enter),
              ),
              // confirm password
              AppTextFormField(
                obscureText: true,
                controller: confirmPasswordTextController,
                hintText: S.of(context).hint_confirm_password,
                onChange: cubit.setConfirmPassword,
                validator: (value) => AppValidator.validateConfirmPassword(
                  value,
                  passwordTextController.text,
                  S.of(context).valid_confirm_password_enter,
                  S.of(context).valid_confirm_password_mismatch,
                ),
              ),
              const SizedBox(height: 16),
              ButtonPurple(
                textButton: S.of(context).button_sign_up,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.onPressSignUp();
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      cubit.onPressLogIn();
                    },
                    child: Text(S.of(context).button_log_in),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
