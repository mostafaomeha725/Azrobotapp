import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/reminders_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersView extends StatefulWidget {
  const RemindersView({super.key});

  @override
  State<RemindersView> createState() => _RemindersViewState();
}

class _RemindersViewState extends State<RemindersView> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndReminders();
  }

  Future<void> _loadUserIdAndReminders() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");

    if (userId != null) {
      // ignore: use_build_context_synchronously
      context.read<ReminderCubit>().loadReminders(userId!);
    } else {
      debugPrint("userId not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReminderCubit(),
      child: Scaffold(
        appBar: AppBar(
      
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.assetsazrobotlogoonly, height: 32),
              const SizedBox(width: 8),
              Text(
                'Reminders',
                style: TextStyles.bold20w600.copyWith(color: const Color(0xFF0062CC)),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const RemindersViewBody(),
      ),
    );
  }
}
