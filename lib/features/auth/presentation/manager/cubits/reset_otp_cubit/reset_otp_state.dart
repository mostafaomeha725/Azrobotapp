part of 'reset_otp_cubit.dart';

@immutable
sealed class ResetOtpState {}

final class ResetOtpInitial extends ResetOtpState {}

final class ResetOtpLoading extends ResetOtpState {}

final class ResetOtpSuccess extends ResetOtpState {}

final class ResetOtpFailure extends ResetOtpState {
  final String errMessage;

  ResetOtpFailure({required this.errMessage});
}
