import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_dimen.dart';
import 'package:todo_app/common/app_icons.dart';
import 'package:todo_app/common/app_images.dart';
import 'package:todo_app/common/app_text_style.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/global/user_state.dart';
import 'package:todo_app/repository/profile_repository.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/ui/loading/app_loading_indicator.dart';
import 'package:todo_app/ui/page/home/home_cubit.dart';
import 'package:todo_app/ui/page/home/home_state.dart';
import 'package:todo_app/ui/widgets/button_purple.dart';
import 'package:todo_app/ui/widgets/todo_item.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/utils/app_date_utils.dart';
import 'home_navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) {
        return HomeCubit(
          navigator: HomeNavigator(context: context),
          profileRepo: context.read<ProfileRepository>(),
          todoRepo: context.read<TodoRepository>(),
          userCubit: context.read<UserCubit>(),
        );
      },
      child: HomePageChild(),
    );
  }
}

// dependency injection

class HomePageChild extends StatefulWidget {
  const HomePageChild({super.key});

  @override
  State<HomePageChild> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageChild> with RouteAware {
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _cubit.fetchInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildHeader(context, state),

              if (state.loadingList)
                const Center(child: AppCircularProgressIndicator())
              else
                Positioned(
                  top: 170,
                  right: 0,
                  left: 0,
                  bottom: 120,
                  child: _buildSuccessList(context, state),
                ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding
                      : const EdgeInsets.all(AppDimen.paddingNormal),
                  child: ButtonPurple(
                    onTap: () =>
                        context.read<HomeCubit>().onPressAddTaskBtn(),
                    textButton: S.of(context).button_add_new_task,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );



  }

  Widget _buildHeader(BuildContext context, HomeState state)  {
    return Container(
      height: 222,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImages.headerImg), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder:(context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 40),
                  Text(AppDateUtils.formatDateNow(DateTime.now()), style: AppTextStyle.titleSmall),
                  Align(
                    alignment: Alignment.topRight,
                    child:  IconButton(
                      onPressed: () {
                        context.read<HomeCubit>().onPressAvatar();
                      },
                      icon: CircleAvatar(
                        backgroundImage: (state.profile?.avatarLink != null && state.profile!.avatarLink!.isNotEmpty)
                            ? NetworkImage(state.profile!.avatarLink!)
                            : AssetImage(AppIcons.icAvatar),
                        radius: 20,
                      ),
                      iconSize: 40,
                    )
                  ),
                ],
              ),

              Text(S.of(context).title_app, style: AppTextStyle.titleApp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessList(BuildContext context, HomeState state) {
    final cubit = context.read<HomeCubit>();
    final unCompletedTodos = state.unCompletedTodos;
    final completedTodos = state.completedTodos;
    return Container(
      margin: EdgeInsets.all(AppDimen.marginNormal),
      child: (unCompletedTodos.isEmpty && completedTodos.isEmpty)
          ? Center(child: Text(S.of(context).label_list_empty, style: AppTextStyle.bodyMedium))
          : CustomScrollView(
              slivers: [
                // uncompleted list
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final todo = unCompletedTodos[index];
                    final currentList = todo.isCompleted ? completedTodos : unCompletedTodos;
                    final currentIndex = currentList.indexOf(todo);
                    return TodoItem(
                      todo: todo,
                      borderRadius: AppDimen.getBorderRadius(currentIndex, currentList.length),
                      onTap: () => cubit.onPressItem(todo),
                      onDismissed: () => cubit.deleteTask(todo.id!),
                      toggleCompleteStatus: () =>
                          cubit.toggleCompleted(todo.id!, todo.isCompleted),
                    );
                  }, childCount: unCompletedTodos.length),
                ),

                // header
                if (completedTodos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppDimen.paddingNormal),
                      child: Text(
                        S.of(context).label_completed,
                        style: unCompletedTodos.isEmpty
                            ? AppTextStyle.titleSmall
                            : AppTextStyle.bodyMedium,
                      ),
                    ),
                  ),

                // completedTodos
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final todo = completedTodos[index];
                    final currentList = todo.isCompleted ? completedTodos : unCompletedTodos;
                    final currentIndex = currentList.indexOf(todo);
                    return TodoItem(
                      todo: todo,
                      borderRadius: AppDimen.getBorderRadius(currentIndex, currentList.length),
                      onTap: () => cubit.onPressItem(todo),
                      onDismissed: () => cubit.deleteTask(todo.id!),
                      toggleCompleteStatus: () => cubit.toggleCompleted(todo.id!, todo.isCompleted),
                    );
                  }, childCount: completedTodos.length),
                ),
              ],
            ),
    );
  }
}
