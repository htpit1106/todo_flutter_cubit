import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_dimen.dart';
import 'package:todo_app/common/app_icons.dart';
import 'package:todo_app/common/app_images.dart';
import 'package:todo_app/common/app_text_style.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/model/entities/todo_entity.dart';
import 'package:todo_app/model/enum/category.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/ui/page/add_task/add_task_cubit.dart';
import 'package:todo_app/ui/page/add_task/add_task_navigator.dart';
import 'package:todo_app/ui/page/add_task/add_task_state.dart';
import 'package:todo_app/ui/page/add_task/widget/button_category.dart';
import 'package:todo_app/ui/widgets/app_text_form_field.dart';
import 'package:todo_app/ui/widgets/button_purple.dart';
import 'package:todo_app/utils/app_date_utils.dart';
import 'package:todo_app/utils/app_validator.dart';

class AddTaskPage extends StatelessWidget {
  final TodoEntity? todo;

  const AddTaskPage({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTaskCubit(
        navigator: AddTaskNavigator(context: context),
        todoRepos: context.read<TodoRepository>(),
        todo: todo,
      ),
      child: AddTaskChildPage(todo: todo),
    );
  }
}

class AddTaskChildPage extends StatefulWidget {
  final TodoEntity? todo;

  const AddTaskChildPage({super.key, this.todo});

  @override
  State<AddTaskChildPage> createState() => _AddTaskChildPageState();
}

class _AddTaskChildPageState extends State<AddTaskChildPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  late AddTaskCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AddTaskCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final todo = widget.todo;
      if (todo != null) {
        cubit.initialData(todo);
        _titleController.text = todo.title ?? "";
        _notesController.text = todo.notes ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final titlePage = widget.todo != null ? "Edit Task" : S.of(context).title_add_new_task;
    return Scaffold(
      body: BlocBuilder<AddTaskCubit, AddTaskState>(
        builder: (context, state) {
          DateTime date = DateTime.parse(state.todo.time!);
          TimeOfDay time = TimeOfDay.fromDateTime(DateTime.parse(state.todo.time!));
          _dateController.text = AppDateUtils.formatDate(date);
          _timeController.text = AppDateUtils.formatTimeOfDayToString(time);

          return Column(
            children: [
              _buildHeader(titlePage),
              const SizedBox(height: 24),
              _buildForm(context, state),
              _buildSaveButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImages.headerImg), fit: BoxFit.cover),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => cubit.goBackHome(result: false),
                icon: Image.asset(AppIcons.icButtonBack, width: 40, height: 40),
              ),
              Expanded(
                child: Text(title, style: AppTextStyle.titleSmall, textAlign: TextAlign.center),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AddTaskState state) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimen.paddingNormal),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField(
                controller: _titleController,
                textLabel: S.of(context).label_task_title,
                hintText: S.of(context).hint_task_title,
                validator: (v) => AppValidator.validateEmpty(v, S.of(context).valid_field_empty),
              ),

              const SizedBox(height: 24),

              // CATEGORY
              Row(
                children: [
                  Text(S.of(context).label_category, style: AppTextStyle.bodyMedium),
                  const SizedBox(width: 8),
                  Row(
                    children: Category.values.map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ButtonCategory(
                          icPosition: _categoryIcon(c),
                          borderColor: state.todo.category == c ? Colors.black : Colors.white,
                          onTap: () => cubit.setCategory(c),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Flexible(
                    child: AppTextFormField(
                      controller: _dateController,
                      readOnly: true,
                      textLabel: S.of(context).label_date,
                      hintText: S.of(context).hint_date,
                      icSuffix: AppIcons.icCalendar,
                      onTap: () async {
                        final date = await AppDateUtils.pickerDateShow(context, cubit.date);
                        cubit.setDate(date);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: AppTextFormField(
                      controller: _timeController,
                      readOnly: true,
                      textLabel: S.of(context).label_time,
                      hintText: S.of(context).hint_time,
                      icSuffix: AppIcons.icClock,
                      onTap: () async {
                        final time = await AppDateUtils.pickerTimeShow(context, cubit.time);
                        cubit.setTime(time);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              AppTextFormField(
                controller: _notesController,
                textLabel: S.of(context).label_notes,
                hintText: S.of(context).hint_notes,
                isMultiLine: true,
                minLine: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimen.paddingNormal),
      child: ButtonPurple(
        textButton: S.of(context).button_save,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            cubit.saveTask(
              todo: widget.todo,
              title: _titleController.text,
              notes: _notesController.text,
            );
          }
        },
      ),
    );
  }

  String _categoryIcon(Category c) {
    switch (c) {
      case Category.task:
        return AppIcons.icCategoryTask;
      case Category.goal:
        return AppIcons.icCategoryGoal;
      case Category.event:
        return AppIcons.icCategoryEvent;
    }
  }
}
