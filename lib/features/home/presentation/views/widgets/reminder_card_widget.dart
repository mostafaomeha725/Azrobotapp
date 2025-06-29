import 'package:azrobot/core/helper/notification/schedula_reminder_notification.dart';
import 'package:azrobot/features/account/data/note_model.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/reminder_cubit/cubit/reminder_cubit.dart';
import 'package:azrobot/features/auth/presentation/widgets/hint_text_auth.dart';
import 'package:flutter/material.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderCardWidget extends StatefulWidget {
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

  @override
  State<ReminderCardWidget> createState() => _ReminderCardWidgetState();
}

class _ReminderCardWidgetState extends State<ReminderCardWidget> {
  late BuildContext _dialogContext;

  @override
  void initState() {
    super.initState();
    scheduleReminderNotification(
      id: widget.index,
      title: widget.title,
      body: 'Your reminder for "${widget.title}" is due now!',
      dateStringFromUI: widget.dateTime,
      repeat: widget.repeat,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dialogContext = context;
  }

  void _showUpdateReminderDialog() {
    final _titleController = TextEditingController(text: widget.title);
    final _dateController = TextEditingController(text: widget.dateTime);
    String _selectedRepeat = widget.repeat;

    Future<void> _selectDateTime() async {
      DateTime? selectedDate = await showDatePicker(
        context: _dialogContext,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        TimeOfDay? selectedTime = await showTimePicker(
          context: _dialogContext,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          int hour = selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
          String amPm = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
          String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
          String formattedDateTime =
              "$formattedDate $hour:${selectedTime.minute.toString().padLeft(2, '0')} $amPm";
          _dateController.text = formattedDateTime;
        }
      }
    }

    showDialog(
      context: _dialogContext,
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
                        onPressed: _selectDateTime,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getString("userId");
                          if (userId != null) {
                            _dialogContext.read<ReminderCubit>().deleteReminder(
                                  userId: userId,
                                  index: widget.index,
                                );
                            await flutterLocalNotificationsPlugin.cancel(widget.index);
                            print('🔔 تم إلغاء الإشعار بمعرف: ${widget.index}');
                            GoRouter.of(_dialogContext).pop();
                          } else {
                            ScaffoldMessenger.of(_dialogContext).showSnackBar(
                              SnackBar(content: Text("User ID not found. Please login again.")),
                            );
                          }
                        },
                        child: Text(
                          "Delete",
                          style: TextStyles.bold12w500.copyWith(color: Colors.white),
                        ),
                      ),
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

                              _dialogContext.read<ReminderCubit>().updateReminder(
                                    userId: userId,
                                    updatedReminder: updatedReminder,
                                    index: widget.index,
                                  );

                              await scheduleReminderNotification(
                                id: widget.index,
                                title: message,
                                body: 'Your reminder for "$message" is due now!',
                                dateStringFromUI: date,
                                repeat: repeatValue,
                              );

                              print('✅ تم تحديث الإشعار بمعرف: ${widget.index}');
                              GoRouter.of(_dialogContext).pop();
                            } else {
                              ScaffoldMessenger.of(_dialogContext).showSnackBar(
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
    return GestureDetector(
      onTap: _showUpdateReminderDialog,
      child: Container(
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
                Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text("${widget.repeat} - ${widget.dateTime}", style: const TextStyle(color: Colors.white70)),
              ],
            ),
            widget.ishome
                ? IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _showUpdateReminderDialog,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}