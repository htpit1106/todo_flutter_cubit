import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_images.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/ui/page/auth/sign_in/log_in_cubit.dart';
import 'package:todo_app/ui/page/auth/sign_in/log_in_navigator.dart';
import 'package:todo_app/ui/widgets/app_text_form_field.dart';
import 'package:todo_app/ui/widgets/button_purple.dart';
import 'package:todo_app/utils/app_validator.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogInCubit>(
      create: (context) {
        return LogInCubit(
          navigator: LogInNavigator(context: context), authRepos: context.read<AuthRepository>(),
        );
      },
      child: LogInPageChild(),
    );
  }
}

class LogInPageChild extends StatefulWidget {
  const LogInPageChild({super.key});

  @override
  State<LogInPageChild> createState() => _LogInPageChildState();
}

class _LogInPageChildState extends State<LogInPageChild> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {


    final cubit = context.read<LogInCubit>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 156),
              Image.asset(AppImages.loginImg, height: 128, width: 128, fit: BoxFit.cover),

              const SizedBox(height: 28),
              AppTextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                hintText: S.of(context).hint_email,
                onChange: cubit.setEmail,
                validator: (value) => AppValidator.validateEmail(value, S.of(context).valid_email_required, S.of(context).valid_email_format),
              ),

              // password
              AppTextFormField(
                obscureText: true,
                controller: passwordController,
                hintText: S.of(context).hint_password,
                onChange: cubit.setPassword,
                validator: (value) => AppValidator.validatePassword(value, S.of(context).valid_password_enter),
              ),

              // confirm password
              const SizedBox(height: 16),
              ButtonPurple(
                textButton: S.of(context).button_login,
                onTap: () {
                  if (_formKey.currentState!.validate()){
                    cubit.login();
                  }
                  //
                },
              ),
              const SizedBox(height: 24),
              _buildSignInWidget(cubit),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  _buildSignInWidget(LogInCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            cubit.onPressSignup();
          },
          child: Text(S.of(context).button_sign_up),
        ),
        SizedBox(width: 10),
        TextButton(onPressed: () {}, child: Text(S.of(context).button_forgot_password)),
      ],
    );
  }
}
