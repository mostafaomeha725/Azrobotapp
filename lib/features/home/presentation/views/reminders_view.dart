import 'package:azrobot/core/app_router/app_router.dart';
import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/reminders_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersView extends StatefulWidget {
  const RemindersView({super.key});

  @override
  State<RemindersView> createState() => _RemindersViewState();
}

class _RemindersViewState extends State<RemindersView> {
String? userId;
  
  // ignore: unused_element
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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40, 
              decoration: BoxDecoration(
                color: Color(0xFF0062CC), 
                borderRadius:
                    BorderRadius.circular(10), 
              ),
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left_sharp,
                  color: Colors.white, 
                  size: 24, 
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(
                      AppRouter.kBersistentBottomNavBarView,
                    ); 
                  }
                },
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // لجعل النص والشعار في الوسط
              children: [
                Image.asset(Assets.assetsazrobotlogoonly, height: 32),
                SizedBox(width: 8),
                Text(
                  'Reminders',
                  style:
                      TextStyles.bold20w600.copyWith(color: Color(0xFF0062CC)),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: RemindersViewBody(),
      ),
    );
  }
}
