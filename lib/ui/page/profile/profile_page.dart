import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/app_icons.dart';
import 'package:todo_app/common/app_text_style.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/global/user_cubit.dart';
import 'package:todo_app/global/user_state.dart';
import 'package:todo_app/repository/auth_repository.dart';

import 'package:todo_app/ui/page/profile/profile_cubit.dart';
import 'package:todo_app/ui/page/profile/profile_navigator.dart';
import 'package:todo_app/ui/page/profile/widget/menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        authRepo: context.read<AuthRepository>(),
        navigator: ProfileNavigator(context: context),
      ),
      child: const ProfilePageChild(),
    );
  }

}

class ProfilePageChild extends StatefulWidget {

  const ProfilePageChild({super.key});

  @override
  State<ProfilePageChild> createState() => _ProfilePageChildState();
}

class _ProfilePageChildState extends State<ProfilePageChild> {

  late final ProfileCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = context.read<ProfileCubit>();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          // CÁC MỤC MENU
          _buildMenu(context)
        ],
      ),
    );
  }

  _buildMenu(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          MenuItem(
            icon: Icons.edit,
            title: S.of(context).menu_update_profile,
            onTap: () => cubit.onPressUpdateProfile(),
          ),
          MenuItem(
            icon:  Icons.lock_outline,
            title: S.of(context).menu_change_password,
            // onTap: provider.goToChangePassword,
          ),
          MenuItem(
            icon: Icons.shield_outlined,
            title: S.of(context).menu_terms_and_policy,
            // onTap: provider.goToTermsAndPolicy,
          ),
          MenuItem(
            icon: Icons.logout,
            title: S.of(context).menu_logout,
            onTap: cubit.onPressLogOut,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          cubit.onBackHome();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) => Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: state.profile?.avatarLink != null
                  ? Image.network(state.profile!.avatarLink!).image
                  : AssetImage(AppIcons.icAvatar),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.profile?.name ?? "", style: AppTextStyle.bodyMedium),
                Text(state.profile?.email ?? "", style: AppTextStyle.grayBodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
