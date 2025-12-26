import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_icons.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/model/entities/profile/profile_entity.dart';
import 'package:todo_app/repository/profile_repository.dart';
import 'package:todo_app/services/storage_service.dart';
import 'package:todo_app/ui/loading/app_loading_indicator.dart';
import 'package:todo_app/ui/page/profile/update_profile/update_profile_cubit.dart';
import 'package:todo_app/ui/page/profile/update_profile/update_profile_navigator.dart';
import 'package:todo_app/ui/page/profile/update_profile/update_profile_state.dart';
import 'package:todo_app/ui/widgets/app_text_form_field.dart';
import 'package:todo_app/ui/widgets/button_purple.dart';
import 'package:todo_app/utils/app_date_utils.dart';
import 'package:todo_app/utils/app_validator.dart';
import 'package:todo_app/generated/l10n.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (context) {
        return UpdateProfileCubit(
          navigator: UpdateProfileNavigator(context: context),
          userCubit: context.read<UserCubit>(),
          storageService: StorageService(),
          profileRepo: context.read<ProfileRepository>(),
        );
      },
      child: UpdateProfilePageChild(),
    );
  }
}

class UpdateProfilePageChild extends StatefulWidget {
  const UpdateProfilePageChild({super.key});

  @override
  State<UpdateProfilePageChild> createState() => _UpdateProfilePageChildState();
}

class _UpdateProfilePageChildState extends State<UpdateProfilePageChild> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedTime = DateTime.now();
  late final UpdateProfileCubit cubit;
  late final ProfileEntity? profile;

  @override
  void initState() {
    super.initState();
    cubit = context.read<UpdateProfileCubit>();
    profile = cubit.state.profile;

    // cubit.state.profile?
    if (profile == null) return;

    nameController.text = profile?.name ?? "";
    emailController.text = profile?.email ?? "";
    if (profile?.birth != null) {
      selectedTime = AppDateUtils.toDateTime(profile!.birth!);
    }
    birthController.text = AppDateUtils.formatDate(selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).title_update_profile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildUpdateForm(context),
      ),
    );
  }

  Widget _buildUpdateForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const AppCircularProgressIndicator();
                    }
                    final avatarLink = state.tempAvatarUrl ?? profile?.avatarLink;

                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: avatarLink != null
                          ? NetworkImage(avatarLink)
                          : const AssetImage(AppIcons.icAvatar) as ImageProvider,
                    );
                  },
                ),

                TextButton(
                  onPressed: () {
                    if (profile == null) return;
                    showImageSourceDialog(context, cubit, profile!);
                  },
                  child: Text(S.of(context).button_upload_avatar),
                ),
              ],
            ),
          ),
          // 2. Name
          AppTextFormField(
            validator: (value) =>
                AppValidator.validateEmpty(value, S.of(context).valid_field_empty),
            hintText: S.of(context).hint_name,
            controller: nameController,
            icPrefix: Icons.person,
          ),

          AppTextFormField(
            readOnly: true,
            validator: (value) => AppValidator.validateEmail(
              value,
              S.of(context).valid_email_enter,
              S.of(context).valid_email_format,
            ),
            hintText: S.of(context).hint_email,
            controller: emailController,
            icPrefix: Icons.email,
          ),

          // 4. Birth Date
          AppTextFormField(
            readOnly: true,
            validator: (value) =>
                AppValidator.validateEmpty(value, S.of(context).valid_field_empty),
            hintText: S.of(context).hint_birthday,
            controller: birthController,
            icPrefix: Icons.calendar_today_outlined,
            onTap: () async {
              selectedTime = await AppDateUtils.pickerDateShow(context, selectedTime);
              birthController.text = AppDateUtils.formatDate(selectedTime);
            },
          ),
          const SizedBox(height: 32),
          // Nút Save
          ButtonPurple(
            textButton: S.of(context).button_save,
            onTap: () {
              if (profile == null) return;

              ProfileEntity newProfile = profile!.copyWith(
                name: nameController.text,
                birth: AppDateUtils.dateToStringISO8601(selectedTime, TimeOfDay.now()),
                avatarLink: cubit.state.tempAvatarUrl,
              );
              if (_formKey.currentState!.validate()) {
                cubit.submitUpdate(newProfile);
              }
            },
          ),
        ],
      ),
    );
  }

  void showImageSourceDialog(
    BuildContext context,
    UpdateProfileCubit cubit,
    ProfileEntity profileEntity,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              // Tùy chọn 1: Camera
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  cubit.pickAndUploadAvatar(profileEntity, ImageSourceType.camera);
                },
              ),

              // Tùy chọn 2: Gallery
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  cubit.pickAndUploadAvatar(profileEntity, ImageSourceType.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
