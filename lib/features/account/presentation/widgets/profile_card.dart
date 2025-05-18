import 'package:azrobot/core/api/end_ponits.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/get_all_spe_cialties_cubits/cubit/getallspecialties_cubit.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/manager/cubits/get_all_city_cubit/getallcity_cubit.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileSuccess) {
          final profile = state.profileData;
          
          // Convert IDs to integers if they come as strings
          final cityId = int.tryParse(profile[ApiKey.data][ApiKey.user][ApiKey.cityId].toString()) ?? 0;
          final specialId = int.tryParse(profile[ApiKey.data][ApiKey.user][ApiKey.specialId].toString()) ?? 0;

          return Padding(
            padding: const EdgeInsets.only(top: 32, right: 16, left: 16),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    title: Text(
                      profile[ApiKey.data][ApiKey.user][ApiKey.name],
                      style: TextStyles.bold16w500
                          .copyWith(color: Color(0xFF0062CC)),
                    ),
                    subtitle: Text(
                      profile[ApiKey.data][ApiKey.user][ApiKey.mobile],
                      style: TextStyles.bold13w500.copyWith(color: Colors.grey),
                    ),
                   
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<GetallspecialtiesCubit, SpecialtiesState>(
                          builder: (context, state) {
                            final special = context
                                .read<GetallspecialtiesCubit>()
                                .getSpecialNameById(specialId);
                            return Text(
                              special ?? 'Unknown Specialty',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              textDirection: TextDirection.ltr,
                            );
                          },
                        ),
                        BlocBuilder<GetallcityCubit, GetallcityState>(
                          builder: (context, state) {
                            final cityName = context
                                .read<GetallcityCubit>()
                                .getCityNameById(cityId);
                            return Text(
                              cityName ?? 'Unknown City',
                              style: TextStyles.bold13w500
                                  .copyWith(color: Colors.grey),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      profile[ApiKey.data][ApiKey.user][ApiKey.email] ?? "",
                      style: TextStyles.bold13w500.copyWith(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          );
        } else if (state is ProfileFailure) {
          return Center(
            child: Text(
              'Error: ${state.errMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }
}