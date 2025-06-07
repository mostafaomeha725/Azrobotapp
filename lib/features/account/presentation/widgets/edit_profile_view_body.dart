import 'package:azrobot/core/api/end_ponits.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/account/presentation/widgets/Edit_Drop_down_Field_Widget.dart';
import 'package:azrobot/features/account/presentation/widgets/Edit_Text_Field_widget.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/cubit/updateprofile_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileViewBody extends StatefulWidget {
  const EditProfileViewBody({
    super.key,
    required this.profile,
    required this.cityName,
    required this.speciality,
  });

  final Map<String, dynamic> profile;
  final String cityName;
  final String speciality;

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  int? selectedCityId;
  int? selectedSpecialityId;
  late int originalCityId;
  late int originalSpecialityId;

  @override
  void initState() {
    super.initState();
    final user = widget.profile[ApiKey.data][ApiKey.user];

    nameController = TextEditingController(text: user[ApiKey.name]);
    mobileController = TextEditingController(text: user[ApiKey.mobile]);

    originalCityId = int.tryParse(user[ApiKey.cityId].toString()) ?? 0;
    originalSpecialityId = int.tryParse(user[ApiKey.specialId].toString()) ?? 0;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  Future<void> _updateField({
    String? name,
    String? mobile,
    int? cityId,
    int? specialityId,
  }) async {
    await context.read<UpdateprofileCubit>().updateProfile(
          name: name ?? nameController.text,
          mobile: mobile ?? mobileController.text,
          mainCity: (cityId ?? selectedCityId ?? originalCityId).toString(),
          specialty: (specialityId ?? selectedSpecialityId ?? originalSpecialityId).toString(),
        );
    SharedPreference().clearProfileCache();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 32, right: 16, left: 16),
      child: Column(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    title: Text(
                      nameController.text,
                      style: TextStyles.bold16w500.copyWith(color: const Color(0xFF1752A8)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name Field
                  EditTextFieldWidget(
                    title: nameController.text,
                    text: 'Name',
                    onChanged: (val) {
                      setState(() {
                        nameController.text = val;
                      });
                    },
                    onSubmit: (val) async {
                      await _updateField(name: val);
                    },
                  ),

                  // Mobile Field
                  EditTextFieldWidget(
                    title: mobileController.text,
                    text: 'Mobile Number',
                    onChanged: (val) {
                      setState(() {
                        mobileController.text = val;
                      });
                    },
                    onSubmit: (val) async {
                      await _updateField(mobile: val);
                    },
                  ),

                  // Speciality Dropdown
                  EditDrodownFieldWidget(
                    title: widget.speciality,
                    text: 'Speciality',
                    iscity: false,
                    onChanged: (id) async {
                      setState(() {
                        selectedSpecialityId = id;
                      });
                      await _updateField(specialityId: id);
                    },
                  ),

                  // City Dropdown
                  EditDrodownFieldWidget(
                    title: widget.cityName,
                    text: 'City',
                    iscity: true,
                    onChanged: (id) async {
                      setState(() {
                        selectedCityId = id;
                      });
                      await _updateField(cityId: id);
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // BlocBuilder to show state changes
          BlocBuilder<UpdateprofileCubit, UpdateprofileState>(
            builder: (context, state) {
              if (state is UpdateprofileLoading) {
                return const CircularProgressIndicator();
              } else if (state is UpdateprofileSuccess) {
                return const Text("Updated successfully", style: TextStyle(color: Colors.green));
              } else if (state is UpdateprofileFailure) {
                return Text(state.error, style: const TextStyle(color: Colors.red));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
