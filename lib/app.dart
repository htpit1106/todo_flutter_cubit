import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/common/app_themes.dart';
import 'package:todo_app/configs/app_constants.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/repository/auth_repository.dart';
import 'package:todo_app/repository/profile_repository.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/router/app_router.dart';
import 'package:todo_app/generated/l10n.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(supabase: Supabase.instance.client),
        ),
        RepositoryProvider<TodoRepository>(
          create: (_) => TodoRepositorImpl(supabase: Supabase.instance.client),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepositoryImpl(supabase: Supabase.instance.client),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(
              profileRepo: context.read<ProfileRepository>(),
              supabase: Supabase.instance.client,
            ),
          ),
        ],
        child: const TodoAppChild(),
      ),
    );
  }
}

class TodoAppChild extends StatefulWidget {
  const TodoAppChild({super.key});

  @override
  State<TodoAppChild> createState() => _TodoAppChildState();
}

class _TodoAppChildState extends State<TodoAppChild> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: AppConstants.appName,
      theme: AppThemes().theme,
      locale: const Locale('en'),
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
