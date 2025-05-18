part of 'reminder_cubit.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class ReminderSuccess extends ReminderState {
  final List<ReminderModel> reminders;

  const ReminderSuccess(this.reminders);

  @override
  List<Object> get props => [reminders];
}

class ReminderFailure extends ReminderState {
  final String message;

  const ReminderFailure(this.message);

  @override
  List<Object> get props => [message];
}