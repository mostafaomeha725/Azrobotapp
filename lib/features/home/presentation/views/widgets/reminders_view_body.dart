import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/home/presentation/views/widgets/add_reminders_card.dart';
import 'package:azrobot/features/home/presentation/views/widgets/reminder_card_widget.dart';

class RemindersViewBody extends StatefulWidget {
  const RemindersViewBody({super.key});

  @override
  State<RemindersViewBody> createState() => _RemindersViewBodyState();
}

class _RemindersViewBodyState extends State<RemindersViewBody> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const AddRemindersCard(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ReminderCubit, ReminderState>(
              builder: (context, state) {
                if (state is ReminderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ReminderFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is ReminderSuccess) {
                  final originalReminders = state.reminders;
                  final reminders = originalReminders.reversed.toList(); // ← عكس الترتيب

                  if (reminders.isEmpty) {
                    return const Center(child: Text('No reminders yet.'));
                  }

                  return ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ReminderCardWidget(
                          title: reminder.reminderText,
                          repeat: reminder.repeat,
                          dateTime: reminder.dateTime,
                          userId: userId!,
                          index: originalReminders.indexOf(reminder), // ← استخدام index الأصلي
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Unexpected state.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
