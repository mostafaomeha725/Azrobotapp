import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/features/account/presentation/widgets/language_card.dart';
import 'package:azrobot/features/account/presentation/widgets/more_card.dart';
import 'package:azrobot/features/account/presentation/widgets/profile_card.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/sign_out_cubit/cubit/sign_out_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
class AccountViewBody extends StatelessWidget {
  const AccountViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logged out successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );

          GoRouter.of(context).pushReplacement(AppRouter.kLoginView);


      
        } else if (state is SignOutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errMessage}')),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const ProfileCard(key: ValueKey('profile_card')),
              const SizedBox(height: 8),
           
              MoreCard(
                key: const ValueKey('offers_history'),
                icon: Icons.notifications_outlined,
                title: 'Offers History',
                onTap: () {
                  GoRouter.of(context).go(AppRouter.kOfferHistoryView);
                },
              ),
              MoreCard(
                key: const ValueKey('privacy_policy'),
                icon: Icons.local_police_outlined, 
                title: 'Privacy Policy',
              ),
              MoreCard(
                key: const ValueKey('terms_conditions'),
                icon: Icons.privacy_tip_outlined,
                title: 'Terms & Conditions',
              ),
              const SizedBox(height: 56),
              MoreCard(
                key: const ValueKey('logout_button'),
                icon: Icons.exit_to_app_outlined,
                title: 'Log Out',
                onTap: () {
                  context.read<SignOutCubit>().logOutUser();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}