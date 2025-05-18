import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/auth/presentation/widgets/hint_text_auth.dart';
import 'package:azrobot/features/home/presentation/views/widgets/repeat_widget_reminders.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReminderSheet {
 
  
  Future<void> _loadUserIdAndReminders() async {
     String? userId;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");

  
  }
  static void addReminderSheet(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _dateTimeController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _reminderTextController =
        TextEditingController();
    // ignore: unused_local_variable
    String selectedRepeat = 'Once';

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _selectDateTime(BuildContext context) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        TimeOfDay? selectedTime = await showTimePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          int hour =
              selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
          String amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

          DateFormat dateFormat = DateFormat('MM/dd/yyyy');
          String formattedDate = dateFormat.format(selectedDate);

          String formattedDateTime =
              "$formattedDate $hour:${selectedTime.minute.toString().padLeft(2, '0')} $amPm";

          _dateTimeController.text = formattedDateTime;
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff44ded1),
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Add Reminders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    HintTextAuth(hint: "Date & Time"),
                    SizedBox(height: 4),
                    TextFormField(
                      onTap: () => _selectDateTime(context),
                      controller: _dateTimeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: 16),
                    HintTextAuth(hint: 'Reminder for:'),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: _reminderTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    HintTextAuth(hint: 'Repeat:'),
                    SizedBox(height: 4),
                    RepeatWidgetReminders(
                      onChanged: (value) {
                        selectedRepeat = value;
                      },
                    ),
                    SizedBox(height: 16),
                   ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xff134FA2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onPressed: () async {
   final date = _dateTimeController.text;
  final message = _reminderTextController.text;

  if (date.isNotEmpty && message.isNotEmpty) {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId != null) {
      context.read<ReminderCubit>().addReminder(
        reminderText: message,
        dateTime: date,
        repeat: selectedRepeat,
        userId: userId,
      );
      GoRouter.of(context).pop();
    } else {
      // التعامل مع حالة عدم وجود userId
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found. Please login again.")),
      );
    }
  }
  },
  child: Text(
    "Set",
    style: TextStyles.bold12w500.copyWith(color: Colors.white),
  ),
),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
