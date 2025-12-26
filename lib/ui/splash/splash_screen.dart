import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_images.dart';
import 'package:todo_app/ui/splash/splash_cubit.dart';
import 'package:todo_app/ui/splash/splash_navigator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) {
        return SplashCubit(navigator: SplashNavigator(context: context));
      },
      child: SplashScreenChild(),
    );
  }
}

class SplashScreenChild extends StatefulWidget {
  const SplashScreenChild({super.key});

  @override
  State<SplashScreenChild> createState() => _SplashScreenChildState();
}

class _SplashScreenChildState extends State<SplashScreenChild> {
  late final SplashCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = context.read<SplashCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      cubit.autoLogin();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.splashImg, height: 128, width: 128, fit: BoxFit.cover),
      ),
    );
  }
}
