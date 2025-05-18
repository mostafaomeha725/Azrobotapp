import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/home/presentation/views/widgets/add_reminder_sheet.dart';
import 'package:flutter/material.dart';

class AddRemindersCard extends StatelessWidget {
  const AddRemindersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: () {
          AddReminderSheet.addReminderSheet(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xff134FA2)),
            Text(
              "Add Reminders",
              style: TextStyles.bold16w600.copyWith(color: Color(0xff134FA2)),
            ),
          ],
        ),
      ),
    );
  }
}
