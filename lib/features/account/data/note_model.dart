import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class ReminderModel extends HiveObject {
  @HiveField(0)
  final String dateTime;

  @HiveField(1)
  final String reminderText;

  @HiveField(2)
  final String repeat;
 // أضف هذا الحقل

  ReminderModel({
   
    required this.dateTime,
    required this.reminderText,
    required this.repeat,
  });
}