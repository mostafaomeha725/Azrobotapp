import 'package:azrobot/features/account/data/note_model.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/auth/presentation/widgets/hint_text_auth.dart';
import 'package:flutter/material.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderCardWidget extends StatelessWidget {
  final String title;
  final String repeat;
  final String dateTime;
  final bool ishome;
  final String userId;
  final int index;

  const ReminderCardWidget({
    super.key,
    required this.title,
    required this.repeat,
    required this.dateTime,
    required this.userId,
    required this.index,
    this.ishome = true,
  });

  void _showUpdateReminderDialog(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _titleController = TextEditingController(text: title);
    // ignore: no_leading_underscores_for_local_identifiers
    final _dateController = TextEditingController(text: dateTime);
    // ignore: no_leading_underscores_for_local_identifiers
    String _selectedRepeat = repeat;

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
          String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
          String formattedDateTime =
              "$formattedDate $hour:${selectedTime.minute.toString().padLeft(2, '0')} $amPm";
          _dateController.text = formattedDateTime;
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                    'Reminder Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  HintTextAuth(hint: "Date & Time"),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDateTime(context),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  HintTextAuth(hint: 'Reminder for:'),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Reminder",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  HintTextAuth(hint: 'Repeat:'),
                  SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _selectedRepeat,
                    items: ['Once', 'Daily', 'Monthly'].map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (val) => _selectedRepeat = val!,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff134FA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final date = _dateController.text;
                      final message = _titleController.text;
                      final repeatValue = _selectedRepeat;

                      if (date.isNotEmpty && message.isNotEmpty) {
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getString("userId");

                        if (userId != null) {
                          final updatedReminder = ReminderModel(
                            dateTime: date, 
                            reminderText: message,
                            repeat: repeatValue, 
                          );

                          // ignore: use_build_context_synchronously
                          context.read<ReminderCubit>().updateReminder(
                            userId: userId,
                            updatedReminder: updatedReminder,
                            index: index,
                          );

                          GoRouter.of(context).pop();
                        } else {
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF41D5C5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text("$repeat - $dateTime", style: const TextStyle(color: Colors.white70)),
              ],
            ),
            ishome ? GestureDetector(
              onTap: (){
                _showUpdateReminderDialog(context);
              },
              child: const Icon(Icons.edit, color: Colors.white)) : SizedBox(),
          ],
        ),
      
    );
  }
}