

import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/features/account/data/note_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'reminder_state.dart';class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  Future<void> addReminder({
  
    required String dateTime,
    required String reminderText,
    required String repeat,
    required String userId
  }) async {
    emit(ReminderLoading());

    try {
      final box = await Hive.openBox<ReminderModel>('reminders_$userId');

      final reminder = ReminderModel(
        dateTime: dateTime,
        reminderText: reminderText,
        repeat: repeat,
      );

      await box.add(reminder);
      final reminders = box.values.toList();
      emit(ReminderSuccess(reminders));
    } catch (e) {
      emit(ReminderFailure(e.toString()));
    }
  }

  Future<void> loadReminders(String userId) async {
    emit(ReminderLoading());
    try {
      final box = await Hive.openBox<ReminderModel>('reminders_$userId');
      final reminders = box.values.toList();
      emit(ReminderSuccess(reminders));
    } catch (e) {
      emit(ReminderFailure(e.toString()));
    }
  }

  Future<void> updateReminder({
    required String userId,
    required int index,
    required ReminderModel updatedReminder,
  }) async {
    emit(ReminderLoading());
    try {
      final box = await Hive.openBox<ReminderModel>('reminders_$userId');
      await box.putAt(index, updatedReminder);
      final reminders = box.values.toList();
      emit(ReminderSuccess(reminders));
    } catch (e) {
      emit(ReminderFailure('Failed to update reminder: ${e.toString()}'));
    }
  }

  Future<void> deleteReminder({
    required String userId,
    required int index,
  }) async {
    emit(ReminderLoading());
    try {
      final box = await Hive.openBox<ReminderModel>('reminders_$userId');
      await box.deleteAt(index);
      final reminders = box.values.toList();
      emit(ReminderSuccess(reminders));
    } catch (e) {
      emit(ReminderFailure('Failed to delete reminder: ${e.toString()}'));
    }
  }
}
