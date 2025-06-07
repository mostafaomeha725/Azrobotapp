import 'package:azrobot/features/auth/presentation/manager/cubits/cubit/updateprofile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/can_pop_widgets.dart';
import 'package:azrobot/features/account/presentation/widgets/edit_profile_view_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({
    super.key,
    required this.profile,
    required this.special,
    required this.cityName,
  });

  final Map<String, dynamic> profile;
  final String special;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0062CC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                CanPopWidgets().handleBackButton(context);
              },
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: Text(
              "Edit Profile",
              style: TextStyles.bold20w600.copyWith(color: const Color(0xFF1752A8)),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
  create: (_) => UpdateprofileCubit(),
  child: EditProfileViewBody(
    profile: profile,
    cityName: cityName,
    speciality: special,
  ),
)

    );
  }
}
